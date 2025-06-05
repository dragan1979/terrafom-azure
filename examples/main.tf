# Azure Resource Group Module
# This module creates an Azure Resource Group with the specified name and location.
# It also allows for tagging the resource group for better organization and management.
# Ensure you have the Azure provider configured in your Terraform setup.
module "rg1" {

source                                   = "./../rg"
resource_group_name                      = "VNet1-RG"
resource_group_location                  = var.resource_group_location
resource_group_tag                       = "Production"  
}


module "rg2" {

source                                   = "./../rg"
resource_group_name                      = "VNet2-RG"
resource_group_location                  = var.resource_group_location
resource_group_tag                       = "Production"  
}

# Azure Key Vault module
# This module creates an Azure Key Vault and configures it with the necessary settings.
# It uses the Vault provider to manage secrets and access policies.
# Ensure you have the Vault provider configured in your Terraform setup.
# Note:!! Due to RBAC propagation, need to run terraform apply twice to ensure the Key Vault is created and the RBAC permissions are applied correctly.
module "azure_key_vault" {
  source = "./../vault"
  environment_name = var.environment_name
  resource_group_name = module.rg1.resource_group_name
  resource_group_location = module.rg1.resource_group_location
  key_vault_name = "mykeyvault18"
  azure_tenant_id     = data.vault_kv_secret_v2.azure_sp_creds.data.tenant_id
  azure_application_id = data.vault_kv_secret_v2.azure_sp_creds.data.client_id
  azure_object_id     =  data.azuread_service_principal.current.object_id
  network_acl         = ["82.117.216.178/32"]
}

# Azure Virtual Network Module
# This module creates an Azure Virtual Network with specified CIDR blocks and subnets.
# It also allows for enabling/disabling various subnets based on the environment.
# Ensure you have the Azure provider configured in your Terraform setup.
module "azure_vnet1" {
source                                   = "./../vnet"
environment_name                         = var.environment_name
cidr_block                               = "10.11.96.0/19"
dns_servers                              = [
    "8.8.8.8",
    "8.8.4.4", 
     ]
vnet_name                                = "VNET-1"
resource_group_name                      = module.rg1.resource_group_name
resource_group_location                  = module.rg1.resource_group_location
enable_wan_subnet                        = true
# If Storage Endpoint is needed for WAN subnet, set to true
enable_wan_storage_endpoint              = true
enable_dmz_subnet                        = false
enable_vdi_subnet                        = false
enable_infrastructure_services_subnet    = true
enable_infrastructure_db_services_subnet = false
enable_production_app_services_subnet    = false
enable_production_db_services_subnet     = false
enable_acceptance_app_services_subnet    = false
enable_acceptance_db_services_subnet     = false
enable_test_app_services_subnet          = false
enable_test_db_services_subnet           = false
enable_development_app_services_subnet   = false
enable_development_db_services_subnet    = false
enable_gateway_subnet                    = true # Enable gateway subnet for VPN or ExpressRoute}
}

module "azure_vnet2" {
source                                   = "./../vnet"
environment_name                         = "testing"
cidr_block                               = "10.11.64.0/19"
dns_servers                              = [
    "8.8.8.8",
    "8.8.4.4",
]
vnet_name                                = "VNET-2"
resource_group_name                      = module.rg2.resource_group_name
resource_group_location                  = module.rg2.resource_group_location
enable_wan_subnet                        = true
enable_dmz_subnet                        = false
enable_vdi_subnet                        = false
enable_infrastructure_services_subnet    = true
enable_infrastructure_db_services_subnet = false
enable_production_app_services_subnet    = false
enable_production_db_services_subnet     = false
enable_acceptance_app_services_subnet    = false
enable_acceptance_db_services_subnet     = false
enable_test_app_services_subnet          = false
enable_test_db_services_subnet           = false
enable_development_app_services_subnet   = false
enable_development_db_services_subnet    = false
}

# Azure VNET Peering Module
# This module sets up peering between two Azure Virtual Networks.
# It allows for communication between the VNETs while maintaining isolation.
# Ensure you have the Azure provider configured in your Terraform setup.
# This module assumes that the VNETs are in different resource groups or subscriptions.
# Adjust the module source path as necessary to point to your VNET peering module.

module "vnet_peering" {
  source = "./../peering"

  vnet1_id        = module.azure_vnet1.vnet_id # Access the ID from the VNET module output
  vnet1_name      = module.azure_vnet1.vnet_name # Assuming vnet_name is output, or derive from input
  vnet1_rg_name   = module.rg1.resource_group_name # Access from the RG module output

  vnet2_id        = module.azure_vnet2.vnet_id # Access the ID from the VNET1 module output
  vnet2_name      = module.azure_vnet2.vnet_name
  vnet2_rg_name   = module.rg2.resource_group_name
}

# Azure Availability Set Module
# This module creates an Azure Availability Set to ensure high availability for virtual machines.
# It allows you to specify the number of update domains and fault domains.
 

module "availability_set1" {

source                                   = "./../availability_set"
resource_group_name                      = module.rg1.resource_group_name
resource_group_location                  = module.rg1.resource_group_location
environment_name                         = var.environment_name
#Virtual machines in the same update domain will be restarted together during planned maintenance.
availability_set_update_domain_count     = 2
#Virtual machines in the same fault domain share a common power source and physical network switch
availability_set_fault_domain_count      = 2
}


module "availability_set2" {

source                                   = "./../availability_set"
resource_group_name                      = module.rg2.resource_group_name
resource_group_location                  = module.rg2.resource_group_location
environment_name                         = var.environment_name
#Virtual machines in the same update domain will be restarted together during planned maintenance.
availability_set_update_domain_count     = 2
#Virtual machines in the same fault domain share a common power source and physical network switch
availability_set_fault_domain_count      = 2
}


# Azure Virtual Machine Module
# This module creates an Azure Virtual Machine with specified configurations.
# It allows you to specify the OS, VM size, image publisher, and other settings.
# If you need to use disk encryption, ensure the Azure Key Vault module is initialized


module "azure_vm1" {
source = "./../vm"
environment_name = var.environment_name
# To enable disk encryption:
#enable_disk_encryption = true
disk_encryption_set_id = module.azure_key_vault.disk_encryption_set_id # Link to the Disk Encryption Set created in the Key Vault modul
# To disable disk encryption (default behavior if 'enable_disk_encryption' is not set to true):
enable_disk_encryption = [true] # Example: only second VM's OS disk encrypted
instances = 1 # Number of VMs to create
#disk_encryption_set_id = null # or simply omit this if enable_disk_encryption is false
subnet_id = module.azure_vnet1.subnets_id_wan
resource_group_name = module.rg1.resource_group_name
resource_group_location = module.rg1.resource_group_location
availability_set_id = module.availability_set1.availability_set_id
os = "windows"
vm_size = "Standard_B1ms"
vm_image_publisher = "MicrosoftWindowsServer"
vm_image_offer = "WindowsServer"
vm_image_sku = "2022-Datacenter"
vm_name = ["win-vm-01"]
computer_name = ["win01"]
vm_admin = data.vault_kv_secret_v2.windows_vm_credentials.data.username
vm_password = data.vault_kv_secret_v2.windows_vm_credentials.data.password
# disk size of managed disk in GB
disk_sizes  = [[5], [4]] # Example: first VM has 5bGB disk, second VM has 10 GB disk
number_of_managed_disks = [1] # Example: both VMs have 1 managed disk each
public_ip = [false]

depends_on = [
  module.azure_key_vault, # Ensure Key Vault is created before VMs
  module.azure_vnet1,       # Ensure VNet is created before VMs
  module.availability_set1 # Ensure Availability Set is created before VMs
]

}



module "azure_vm2" {
source = "./../vm"
environment_name = var.environment_name
# To enable disk encryption:
#enable_disk_encryption = true
disk_encryption_set_id = module.azure_key_vault.disk_encryption_set_id # Link to the Disk Encryption Set created in the Key Vault modul
# To disable disk encryption (default behavior if 'enable_disk_encryption' is not set to true):
enable_disk_encryption = [false, true] # Example: only second VM's OS disk encrypted
#disk_encryption_set_id = null # or simply omit this if enable_disk_encryption is false
subnet_id = module.azure_vnet2.subnets_id_wan
resource_group_name = module.rg2.resource_group_name
resource_group_location = module.rg2.resource_group_location
availability_set_id = module.availability_set2.availability_set_id
os = "linux"
vm_size = "Standard_B1ms"
vm_image_publisher = "Canonical"
vm_image_offer = "ubuntu-24_04-lts"
vm_image_sku = "server"
vm_name = ["lin-vm-01", "lin-vm-02"]
computer_name = ["lin-01", "lin-02"]
instances = 2
vm_admin = data.vault_kv_secret_v2.linux_vm_credentials.data.username
vm_password = data.vault_kv_secret_v2.linux_vm_credentials.data.password
# disk size of managed disk in GB
disk_sizes  = [[5], [10]] # Example: first VM has 5bGB disk, second VM has 10 GB disk
number_of_managed_disks = [1, 1] # Example: both VMs have 1 managed disk each
public_ip = [false, true]

depends_on = [ 
  module.azure_key_vault, # Ensure Key Vault is created before VMs
  module.azure_vnet2,       # Ensure VNet is created before VMs
  module.availability_set2 # Ensure Availability Set is created before VMs
]

}





# Azure Load Balancer Module
# This module creates an Azure Load Balancer with specified configurations.
# It allows you to define load balancing rules, health probes, and backend pools.
module "azure_load_balancer" {
  source = "./../load-balancer"
  load_balancer_name    = "my-load-balancer"
  environment_name      = "prod"
  lb_name_suffix        = "web-tier"
  resource_group_name   = module.rg1.resource_group_name
  resource_group_location = module.rg1.resource_group_location
  nic_ip_config_name = module.azure_vm1.nic_ip_config_name
  # Load Balancing rules
  probes = {
    "HTTPProbe" = {
      protocol     = "Http"
      port         = 80
      request_path = "/"
    },
    "HTTPSProbe" = {
      protocol     = "Https"
      port         = 443
      request_path = "/"
    }
  }

  load_balancing_rules = {
    "HTTPRule" = {
      protocol                       = "Tcp"
      frontend_port                  = 80
      backend_port                   = 80
      probe_name                     = "HTTPProbe"
    },
    "HTTPSRule" = {
      protocol                       = "Tcp"
      frontend_port                  = 443
      backend_port                   = 443
      probe_name                     = "HTTPSProbe"
    }
  }

  # Backend pool associations
  vm_nic_ids = module.azure_vm1.vm_nic_ids
  

  # For Multiple NAT Rules
  target_nat_vm_id = module.azure_vm1.windows_vm_ids[0]
  
  nat_frontend_port = 8080
  nat_backend_port = 3389 # Common backend port (e.g., RDP)

  # Optional variables (using defaults or overriding)
  allocation_method = "Static"
  availability_zone = ["1"] # Example: Public IP in Zone 1
  sku               = "Standard"

  tags_module = {
    ManagedBy = "Terraform"
  }
  tags_global = {
    Project = "MyWebApp"
  }
}


# Azure Application Gateway Module
# This module creates an Azure Application Gateway with WAF_v2 configuration.
# It allows you to define frontend IP configurations, backend pools, HTTP settings, listeners, and routing rules.

module "application_gateway" {
  source = "./../app-gateway" # Path to your module directory
  app-gateway-name    = "my-app-gateway"
  location            = module.rg1.resource_group_location
  resource_group_name = module.rg1.resource_group_name
  subnet_id           = module.azure_vnet1.subnets_id_gateway
  # SKU for WAF_v2
  sku_tier     = "WAF_v2"
  sku_capacity = 1
  create_public_ip = true # This is the default, can be omitted
  public_ip_allocation_method = "Static" # Static IP for the Application Gateway
  public_ip_sku = "Standard" # Use Standard SKU for WAF_v2
  public_ip_zones = ["1"] # Example: Public IP in multiple zones

  ssl_certificates = [
    {
      name     = "my-app-cert"
      data     = filebase64("${path.module}/cert/1.pfx") # Path to your PFX file
      password = "1"
    },
    # You can add more certificates here if needed
    # {
    #   name     = "another-cert"
    #   data     = filebase64("${path.module}/certs/another-cert.pfx")
    #   password = "another-pfx-password"
    # }
  ]



  frontend_ip_configurations = [
    {
      name                 = "appGatewayFrontendIP"
      # No public_ip_address_id needed here, as module will create it
      #public_ip_address_id = azurerm_public_ip.app_gateway_pip.id
      # private_ip_address = "10.0.1.5" # Uncomment for private frontend
      # private_ip_address_allocation = "Static"
    }
  ]

  frontend_port_configurations = [
    {
      name = "httpPort"
      port = 80
    },
    {
      name = "httpsPort"
      port = 443
    }
  ]

  backend_address_pools = [
    {
      name         = "backendPool"
      ip_addresses = module.azure_vm1.vm_private_ips # Use private IPs of VMs
      # fqdns = ["mybackend.contoso.com"] # Or FQDNs
    }
  ]

  backend_http_settings = [
    {
      name                = "httpSettings"
      cookie_based_affinity = "Disabled"
      port                = 80
      protocol            = "Http"
      request_timeout     = 20
      probe_name          = "healthProbe" # Reference to a probe below
    }
  ]

  http_listeners = [
    {
      name                           = "httpListener"
      frontend_ip_configuration_name = "appGatewayFrontendIP"
      frontend_port_name             = "httpPort"
      protocol                       = "Http"
      # host_name = "example.com" # Uncomment for host-based routing
    }
  ]

  request_routing_rules = [
    {
      name                       = "rule1"
      rule_type                  = "Basic"
      http_listener_name         = "httpListener"
      backend_address_pool_name  = "backendPool"
      backend_http_settings_name = "httpSettings"
    }
  ]

  probes = [
    {
      name              = "healthProbe"
      protocol          = "Http"
      host              = "10.0.2.4" # IP of a backend server for health check
      path              = "/health"
      interval          = 30
      timeout           = 30
      unhealthy_threshold = 3
    }
  ]

  # WAF Configuration
  enable_waf           = true # Set to true to enable WAF
  waf_mode             = "Prevention" # Or "Detection"
  waf_rule_set_type    = "OWASP"
  waf_rule_set_version = "3.2"

  # Optional WAF settings (uncomment and configure as needed)
   waf_disabled_rule_groups = [
    {
      rule_group_name = "REQUEST-942-APPLICATION-ATTACK-SQLI" # Use the correct, exact name from the error list
      rules           = []
    },
    # If you also wanted to disable XSS, you'd use its exact name:
    {
      rule_group_name = "REQUEST-941-APPLICATION-ATTACK-XSS" # Example for XSS
      rules           = []
    },
    # Or, if you meant the OWASP CRS 3.x specific group:
    # {
    #   rule_group_name = "crs_41_sql_injection_attacks" # Another possible valid name depending on rule set version
    #   rules           = []
    # },
    # {
    #   rule_group_name = "crs_41_xss_attacks" # Another possible valid name depending on rule set version
    #   rules           = []
    # },
    # Add other rule groups here as objects, using their exact names from the error list
  ]
   waf_disabled_rules       = [942100] # Example: disable a specific rule ID

   waf_exclusion_rules = [
     {
       match_variable        = "RequestHeaderNames"
       selector_match_operator = "Equals"
       selector              = "User-Agent"
     }
   ]

   waf_custom_rules = [
     {
       name      = "BlockBadIPs"
       priority  = 100
       rule_type = "MatchRule"
       action    = "Block"
       match_conditions = [
         {
           match_variables = [{ variable_name = "RemoteAddr" }]
           operator        = "IPMatch"
           values          = ["192.168.1.1/32", "10.0.0.0/8"]
         }
       ]
     }
   ]
  
  }


# Azure Storage Account Module
# This module creates an Azure Storage Account with specified configurations.
# It allows you to define the account name, resource group, location, and various storage settings.

module "my_storage_account" {
  source = "./../storage-account" # Adjust path as needed

  storage_account_name         = "mystorageaccount20250606" # Must be globally unique and lowercase
  resource_group_name          = module.rg1.resource_group_name
  location                     = module.rg1.resource_group_location
  account_tier                 = "Standard"
  account_replication_type     = "GRS" # Geo-Redundant Storage
  access_tier                  = "Cool"
  is_hns_enabled               = false # Set to true for Data Lake Storage Gen2
  min_tls_version              = "TLS1_2"
  network_rules_enabled        = true
  network_rules_default_action = "Allow" # If not allow, terraform will fail with 403 error
  network_acl_ip_rules         = ["82.117.216.178/32"] # Add your IP if needed for access
  network_rules_bypass         = ["AzureServices"] # Allow Azure services to access

  enable_private_endpoint        = true
  private_endpoint_subnet_id     = module.azure_vnet1.subnets_id_wan # Example: Use the WAN subnet ID
  private_endpoint_subresource_names = ["blob", "file"]
  network_rules_subnet_ids     = module.azure_vnet1.subnets_id_wan   
 
  blob_containers = [
    {
      name        = "app-data"
      access_type = "private"
    },
    {
      name        = "logs"
      access_type = "private"
    }
  ]

  file_shares = [
    {
      name  = "app-files"
      quota = 50 # 50 GB
    }
  ]

  queues = [
    { name = "message-queue" }
  ]

  tables = [
    { name = "userdata" }
  ]


}