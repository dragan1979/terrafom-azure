# Multi-VM Terraform Module - main.tf
# Replace the content of your existing vm/main.tf file with this content

resource "azurerm_windows_virtual_machine" "this" {
  count                        = var.os == "windows" ? var.instances : 0
  name                         = format("%s-%s-VM", var.environment_name, var.vm_name[count.index])
  location                     = var.resource_group_location
  resource_group_name          = var.resource_group_name
  network_interface_ids        = [azurerm_network_interface.this[count.index].id]
  size                         = var.vm_size
  availability_set_id          = var.availability_set_id
  depends_on                   = [var.resource_group_name]
  admin_username               = var.vm_admin
  admin_password               = var.vm_password
  computer_name                = length(var.computer_name) > count.index ? var.computer_name[count.index] : var.vm_name[count.index]

  os_disk {
    name                   = format("%s-%s-OS-disk", var.environment_name, var.vm_name[count.index])
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    # Conditional inclusion based on the boolean flag
    disk_encryption_set_id = length(var.enable_disk_encryption) > count.index && var.enable_disk_encryption[count.index] ? var.disk_encryption_set_id : null
  }

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }
   
  tags = merge({
    Name = format("%s-%s-VM", var.environment_name, var.vm_name[count.index])
  },
    var.tags_module,
    var.tags_global
  )
}

resource "azurerm_virtual_machine_extension" "iis_setup" {
  count                = var.os == "windows" ? var.instances : 0
  name                 = "iis-setup"
  virtual_machine_id   = azurerm_windows_virtual_machine.this[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = jsonencode({
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -EncodedCommand ${textencodebase64(file("${path.module}/bootstrap-scripts/iis.ps1"), "UTF-16LE")}"
  })

  depends_on = [azurerm_windows_virtual_machine.this]
}

resource "azurerm_linux_virtual_machine" "this" {
  count               = var.os == "linux" ? var.instances : 0
  name                = format("%s-%s-VM", var.environment_name, var.vm_name[count.index])
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  availability_set_id = var.availability_set_id
  size                = var.vm_size
  admin_username      = var.vm_admin
  computer_name       = length(var.computer_name) > count.index ? var.computer_name[count.index] : var.vm_name[count.index]
  network_interface_ids = [azurerm_network_interface.this[count.index].id]
  
  admin_ssh_key {
    username   = var.vm_admin
    public_key = file("/home/ja/.ssh/id_rsa.pub")
  }
  
  os_disk {
    name                   = format("%s-%s-OS-disk", var.environment_name, var.vm_name[count.index])
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    # Conditional inclusion based on the boolean flag
    disk_encryption_set_id = length(var.enable_disk_encryption) > count.index && var.enable_disk_encryption[count.index] ? var.disk_encryption_set_id : null
  }
  
  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = "Latest"
  }
  
  custom_data = base64encode(file("${path.module}/bootstrap-scripts/ubuntu-update.sh"))
}

# Create managed disk(s) for each VM
resource "azurerm_managed_disk" "this" {
  count = sum([for i in range(var.instances) : length(var.number_of_managed_disks) > i ? var.number_of_managed_disks[i] : 0])
  
  name                           = format("%s-%s-%d-Managed-Disk", var.environment_name, var.vm_name[local.disk_vm_mapping[count.index].vm_index], local.disk_vm_mapping[count.index].disk_index)
  location                       = var.resource_group_location
  resource_group_name            = var.resource_group_name
  storage_account_type           = "Standard_LRS"
  create_option                  = "Empty"
  disk_size_gb                   = local.disk_vm_mapping[count.index].disk_size
  # Conditional inclusion based on the boolean flag
  disk_encryption_set_id         = length(var.enable_disk_encryption) > local.disk_vm_mapping[count.index].vm_index && var.enable_disk_encryption[local.disk_vm_mapping[count.index].vm_index] ? var.disk_encryption_set_id : null
  
  tags = merge({
    Name = format("%s-%s-%d-Managed-Disk", var.environment_name, var.vm_name[local.disk_vm_mapping[count.index].vm_index], local.disk_vm_mapping[count.index].disk_index + 1)
  })
}

# Locals for disk management
locals {
  # Create a mapping of disk index to VM index and disk size
  disk_vm_mapping = flatten([
    for vm_index in range(var.instances) : [
      for disk_index in range(length(var.number_of_managed_disks) > vm_index ? var.number_of_managed_disks[vm_index] : 0) : {
        vm_index   = vm_index
        disk_index = disk_index
        disk_size  = length(var.disk_sizes) > vm_index && length(var.disk_sizes[vm_index]) > disk_index ? var.disk_sizes[vm_index][disk_index] : 10
      }
    ]
  ])
}

# Attach managed disk
resource "azurerm_virtual_machine_data_disk_attachment" "external" {
  count              = length(azurerm_managed_disk.this)
  managed_disk_id    = azurerm_managed_disk.this[count.index].id
  virtual_machine_id = var.os == "windows" ? azurerm_windows_virtual_machine.this[local.disk_vm_mapping[count.index].vm_index].id : azurerm_linux_virtual_machine.this[local.disk_vm_mapping[count.index].vm_index].id
  lun                = local.disk_vm_mapping[count.index].disk_index + 10
  caching            = "ReadWrite"
  create_option      = "Attach"
  depends_on         = [azurerm_windows_virtual_machine.this, azurerm_linux_virtual_machine.this]
}

# Define a local variable that holds the original VM indices for which a public IP should be created.
# This list will only contain indices where var.public_ip is true AND within the bounds of var.instances.
locals {
  vm_indices_with_public_ip = [
    for i, enabled in var.public_ip : i
    if enabled && i < var.instances
  ]
}

# Create Public IP for each VM
resource "azurerm_public_ip" "datasourceip" {
  count               = length(local.vm_indices_with_public_ip)
  name                = format("%s-%s-Public-IP", var.environment_name, var.vm_name[count.index])
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = merge({
    Name = format("%s-%s-Public-IP", var.environment_name, var.vm_name[count.index])
  })
}

# Create network interface for each VM
resource "azurerm_network_interface" "this" {
  count               = var.instances
  name                = format("%s-%s-Network-Interface", var.environment_name, var.vm_name[count.index])
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = (
      # Check if a Public IP is desired for *this specific* VM instance (using count.index)
      length(var.public_ip) > count.index && var.public_ip[count.index] ?
      # If desired, find the ID of the Public IP resource that corresponds to this VM's index.
      # 'index()' finds the position of the current VM's index (count.index) within our filtered list.
      # Then, we use that position to get the correct Public IP resource from 'azurerm_public_ip.datasourceip'.
      azurerm_public_ip.datasourceip[
        index(local.vm_indices_with_public_ip, count.index)
      ].id :
      # If Public IP is not desired for this VM, set to null.
      null
    )
  }

  tags = merge({
    Name = format("%s-%s-Network-Interface", var.environment_name, var.vm_name[count.index])
  })
}

# Create security group for each VM
resource "azurerm_network_security_group" "this" {
  count               = var.instances
  name                = format("%s-%s-Security-Group", var.environment_name, var.vm_name[count.index])
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = merge({
    Name = format("%s-%s-Security-Group", var.environment_name, var.vm_name[count.index])
  })
}

# Define port mappings based on OS
locals {
  port_rules = var.os == "windows" ? [
    { name = "Allow-Inbound-RDP", port = "3389", priority = 200 },
    { name = "Allow-Inbound-HTTP", port = "80", priority = 210 },
    { name = "Allow-Inbound-HTTPS", port = "443", priority = 220 }
  ] : [
    { name = "Allow-Inbound-SSH", port = "22", priority = 200 },
    { name = "Allow-Inbound-HTTP", port = "80", priority = 210 },
    { name = "Allow-Inbound-HTTPS", port = "443", priority = 220 }
  ]
}

# Create security rules for each port and each VM instance
resource "azurerm_network_security_rule" "Allow_inbound" {
  count                        = var.instances * length(local.port_rules)
  name                        = "${local.port_rules[count.index % length(local.port_rules)].name}"
  priority                    = local.port_rules[count.index % length(local.port_rules)].priority + floor(count.index / length(local.port_rules))
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = local.port_rules[count.index % length(local.port_rules)].port
  source_address_prefix       = "*"
  destination_address_prefixes = [azurerm_network_interface.this[floor(count.index / length(local.port_rules))].private_ip_address]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this[floor(count.index / length(local.port_rules))].name
}

# Attach security group to VM Network interface
resource "azurerm_network_interface_security_group_association" "example" {
  count                     = var.instances
  network_interface_id      = azurerm_network_interface.this[count.index].id
  network_security_group_id = azurerm_network_security_group.this[count.index].id
}