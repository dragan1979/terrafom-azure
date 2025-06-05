# Multi-VM Outputs - outputs.tf
# Replace the content of your existing vm/outputs.tf file with this content

output "windows_vm_ids" {
  value       = var.os == "windows" ? azurerm_windows_virtual_machine.this[*].id : []
  description = "List of Windows VM IDs"
  depends_on = [
    azurerm_windows_virtual_machine.this,
  ]
}

output "windows_vm_names" {
  value       = var.os == "windows" ? azurerm_windows_virtual_machine.this[*].name : []
  description = "List of Windows VM names"
  depends_on = [
    azurerm_windows_virtual_machine.this,
  ]
}

output "linux_vm_ids" {
  value       = var.os == "linux" ? azurerm_linux_virtual_machine.this[*].id : []
  description = "List of Linux VM IDs"
  depends_on = [
    azurerm_linux_virtual_machine.this,
  ]
}

output "linux_vm_names" {
  value       = var.os == "linux" ? azurerm_linux_virtual_machine.this[*].name : []
  description = "List of Linux VM names"
  depends_on = [
    azurerm_linux_virtual_machine.this,
  ]
}

output "vm_subnet_id" {
  description = "The ID of the subnet designated for VMs."
  value       = var.subnet_id
}

output "vm_nic_ids" {
  value       = azurerm_network_interface.this[*].id
  description = "List of network interface IDs for all VMs"
  depends_on = [
    azurerm_network_interface.this,
  ]
}

output "vm_private_ips" {
  value       = azurerm_network_interface.this[*].private_ip_address
  description = "List of Azure VM Private IPs"
  depends_on = [
    azurerm_network_interface.this,
  ]
}

output "azure_vm_security_group_ids" {
  value       = azurerm_network_security_group.this[*].id
  description = "List of Azure Network security group IDs"
  depends_on = [
    azurerm_network_security_group.this,
  ]
}

output "vm_public_ips" {
  description = "The public IP addresses of the VMs, if enabled. Provides an empty string for VMs without a public IP."
  value = [
    for i in range(var.instances) : (
      # Check if public IP is intended for this VM index
      (length(var.public_ip) > i && var.public_ip[i]) ? (
        # If yes, try to find the corresponding public IP address.
        # 'try()' ensures that if 'index()' fails (because 'i' is not in 'local.vm_indices_with_public_ip'),
        # it doesn't throw an error but instead returns the default value ("" in this case).
        try(
          azurerm_public_ip.datasourceip[
            index(local.vm_indices_with_public_ip, i)
          ].ip_address,
          "" # Fallback value if the index() call fails
        )
      ) : (
        "" # Output empty string if public IP is not enabled for this VM
      )
    )
  ]
}

output "vm_private_ip" {
  value       = length(azurerm_network_interface.this) > 0 ? azurerm_network_interface.this[0].private_ip_address : ""
  description = "First Azure VM Private IP (backward compatibility)"
  depends_on = [
    azurerm_network_interface.this,
  ]
}

output "azure_vm_security_group_id" {
  value       = length(azurerm_network_security_group.this) > 0 ? azurerm_network_security_group.this[0].id : ""
  description = "First Azure Network security group ID (backward compatibility)"
  depends_on = [
    azurerm_network_security_group.this,
  ]
}

output "nic_ip_config_name" {
  description = "The name of the primary IP configuration for each VM's NIC."
  value       = azurerm_network_interface.this[0].ip_configuration[0].name
}