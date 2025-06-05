**Azure Infrastructure with Terraform**

This repository contains Terraform configurations to deploy and manage a
comprehensive Azure infrastructure. It leverages a modular approach,
allowing you to create and manage various Azure resources including
Resource Groups, Virtual Networks, Key Vaults, Virtual Machines, Load
Balancers, Application Gateways, and Storage Accounts.

**Table of Contents**

- [Prerequisites](#prerequisites)
- [Terraform and Provider Requirements](#terraform-and-provider-requirements)
- [Modules Overview](#modules-overview)
  - [Azure Resource Group Module](#azure-resource-group-module)
  - [Azure Key Vault Module](#azure-key-vault-module)
  - [Azure Virtual Network Module](#azure-virtual-network-module)
  - [Azure VNET Peering Module](#azure-vnet-peering-module)
  - [Azure Availability Set Module](#azure-availability-set-module)
  - [Azure Virtual Machine Module](#azure-virtual-machine-module)
  - [Azure Load Balancer Module](#azure-load-balancer-module)
  - [Azure Application Gateway Module](#azure-application-gateway-module)
  - [Azure Storage Account Module](#azure-storage-account-module)
- [Usage](#usage)
- [Important Notes](#important-notes)

## Prerequisites

Before you can use these Terraform configurations, ensure you have the
following installed and configured:

- Terraform CLI: [Install
  Terraform](https://learn.hashicorp.com/terraform/getting-started/install)
  (version \>= 1.12.1)

- Azure CLI or Azure PowerShell: Authenticated to your Azure
  subscription.

- Azure Provider Configuration: Ensure your Terraform setup is
  configured to authenticate with Azure.

- Vault Provider Configuration: If using the Key Vault module, ensure
  the Vault provider is configured to retrieve secrets from your
  HashiCorp Vault instance.

- PFX Certificate for Application Gateway: If deploying the Application
  Gateway with SSL, ensure you have your .pfx certificate file and its
  password ready at the specified path (./cert/1.pfx in the example).

## Terraform and Provider Requirements

This configuration has the following Terraform and provider version
requirements:
```
terraform {

required_version = \"\>= 1.12.1\" \# Specifies the minimum required
Terraform version

required_providers {

vault = {

source = \"hashicorp/vault\"

version = \"\~\> 3.0\"

}

azurerm = {

source = \"hashicorp/azurerm\"

version = \"\~\> 3.0\"

}

azuread = {

source = \"hashicorp/azuread\"

version = \"\~\> 2.0\"

   }
 }
}
```
## Modules Overview

This setup utilizes several custom Terraform modules, each responsible
for deploying a specific Azure resource or set of resources. The source
paths indicate that these modules are expected to be located in a parent
directory named ../ relative to where this main configuration resides.

## Azure Resource Group Module

This module creates Azure Resource Groups to logically organize your
resources.

Example Usage:
```
module \"rg1\" {

source = \"./../rg\"

resource_group_name = \"VNet1-RG\"

resource_group_location = var.resource_group_location

resource_group_tag = \"Production\"

}
```
## Azure Key Vault Module

This module creates an Azure Key Vault and configures it with necessary
settings, including access policies.

Example Usage:
```
module \"azure_key_vault\" {

source = \"./../vault\"

environment_name = var.environment_name

resource_group_name = module.rg1.resource_group_name

resource_group_location = module.rg1.resource_group_location

key_vault_name = \"mykeyvault18\"

azure_tenant_id = data.vault_kv_secret_v2.azure_sp_creds.data.tenant_id

azure_application_id =
data.vault_kv_secret_v2.azure_sp_creds.data.client_id

azure_object_id = data.azuread_service_principal.current.object_id

network_acl = \[\"82.117.216.178/32\"\]

}
```
## Azure Virtual Network Module

This module creates an Azure Virtual Network with specified CIDR blocks
and subnets, allowing for flexible network segmentation. Two VNETs are
defined (azure_vnet1 and azure_vnet2).

Example Usage (azure_vnet1):
```
module \"azure_vnet1\" {

source = \"./../vnet\"

environment_name = var.environment_name

cidr_block = \"10.11.96.0/19\"

dns_servers = \[\"8.8.8.8\", \"8.8.4.4\"\]

vnet_name = \"VNET-1\"

resource_group_name = module.rg1.resource_group_name

resource_group_location = module.rg1.resource_group_location

enable_wan_subnet = true

enable_wan_storage_endpoint = true

enable_gateway_subnet = true

\# \... other subnet configurations (e.g., dmz, vdi, infrastructure)

}
```
## Azure VNET Peering Module

This module sets up peering between two Azure Virtual Networks, enabling
communication across them while maintaining isolation.

Example Usage:
```
module \"vnet_peering\" {

source = \"./../peering\"

vnet1_id = module.azure_vnet1.vnet_id

vnet1_name = module.azure_vnet1.vnet_name

vnet1_rg_name = module.rg1.resource_group_name

vnet2_id = module.azure_vnet2.vnet_id

vnet2_name = module.azure_vnet2.vnet_name

vnet2_rg_name = module.rg2.resource_group_name

}
```
## Azure Availability Set Module

This module creates an Azure Availability Set to ensure high
availability for your virtual machines by spreading them across
different fault and update domains. Two availability sets are defined
(availability_set1 and availability_set2).

Example Usage (availability_set1):
```
module \"availability_set1\" {

source = \"./../availability_set\"

resource_group_name = module.rg1.resource_group_name

resource_group_location = module.rg1.resource_group_location

environment_name = var.environment_name

availability_set_update_domain_count = 2

availability_set_fault_domain_count = 2

}
```
## Azure Virtual Machine Module

This module creates Azure Virtual Machines with specified
configurations. It supports both Windows (azure_vm1) and Linux
(azure_vm2) VMs, disk management, and conditional disk encryption via
Key Vault.

Example Usage (azure_vm1 - Windows VM):
```
module \"azure_vm1\" {

source = \"./../vm\"

environment_name = var.environment_name

enable_disk_encryption = \[true\] \# Example: OS disk encrypted

disk_encryption_set_id = module.azure_key_vault.disk_encryption_set_id

instances = 1 \# Number of VMs to create

subnet_id = module.azure_vnet1.subnets_id_wan

resource_group_name = module.rg1.resource_group_name

resource_group_location = module.rg1.resource_group_location

availability_set_id = module.availability_set1.availability_set_id

os = \"windows\"

vm_size = \"Standard_B1ms\"

vm_image_publisher = \"MicrosoftWindowsServer\"

vm_image_offer = \"WindowsServer\"

vm_image_sku = \"2022-Datacenter\"

vm_name = \[\"win-vm-01\"\]

computer_name = \[\"win01\"\]

vm_admin = data.vault_kv_secret_v2.windows_vm_credentials.data.username

vm_password =
data.vault_kv_secret_v2.windows_vm_credentials.data.password

disk_sizes = \[\[5\]\] \# OS disk size

number_of_managed_disks = \[1\] \# Number of data disks

public_ip = \[false\] \# No public IP for this VM

depends_on = \[module.azure_key_vault, module.azure_vnet1,
module.availability_set1\]
```
}

## Azure Load Balancer Module

This module creates an Azure Load Balancer with configurable rules,
health probes, and backend pools to distribute traffic to your virtual
machines.

Example Usage:
```
module \"azure_load_balancer\" {

source = \"./../load-balancer\"

load_balancer_name = \"my-load-balancer\"

environment_name = \"prod\"

lb_name_suffix = \"web-tier\"

resource_group_name = module.rg1.resource_group_name

resource_group_location = module.rg1.resource_group_location

nic_ip_config_name = module.azure_vm1.nic_ip_config_name \# Assumes
\'internal\'

probes = {

\"HTTPProbe\" = { protocol = \"Http\", port = 80, request_path = \"/\" }

\"HTTPSProbe\" = { protocol = \"Https\", port = 443, request_path =
\"/\" }

}

load_balancing_rules = {

\"HTTPRule\" = { protocol = \"Tcp\", frontend_port = 80, backend_port =
80, probe_name = \"HTTPProbe\" }

\"HTTPSRule\" = { protocol = \"Tcp\", frontend_port = 443, backend_port
= 443, probe_name = \"HTTPSProbe\" }

}

vm_nic_ids = module.azure_vm1.vm_nic_ids

target_nat_vm_id = module.azure_vm1.windows_vm_ids\[0\]

nat_frontend_port = 8080

nat_backend_port = 3389

allocation_method = \"Static\"

availability_zone = \[\"1\"\]

sku = \"Standard\"

tags_module = { ManagedBy = \"Terraform\" }

tags_global = { Project = \"MyWebApp\" }

}
```
## Azure Application Gateway Module

This module creates an Azure Application Gateway with WAF_v2
configuration, enabling advanced traffic management and security
features like Web Application Firewall.

Example Usage:
```
module \"application_gateway\" {

source = \"./../app-gateway\"

app-gateway-name = \"my-app-gateway\"

location = module.rg1.resource_group_location

resource_group_name = module.rg1.resource_group_name

subnet_id = module.azure_vnet1.subnets_id_gateway

sku_tier = \"WAF_v2\"

sku_capacity = 1

create_public_ip = true

public_ip_allocation_method = \"Static\"

public_ip_sku = \"Standard\"

public_ip_zones = \[\"1\"\]

ssl_certificates = \[

{ name = \"my-app-cert\", data =
filebase64(\"\${path.module}/cert/1.pfx\"), password = \"1\" }

\]

frontend_ip_configurations = \[{ name = \"appGatewayFrontendIP\" }\]

frontend_port_configurations = \[{ name = \"httpPort\", port = 80 }, {
name = \"httpsPort\", port = 443 }\]

backend_address_pools = \[{ name = \"backendPool\", ip_addresses =
module.azure_vm1.vm_private_ips }\]

backend_http_settings = \[{ name = \"httpSettings\",
cookie_based_affinity = \"Disabled\", port = 80, protocol = \"Http\",
request_timeout = 20, probe_name = \"healthProbe\" }\]

http_listeners = \[{ name = \"httpListener\",
frontend_ip_configuration_name = \"appGatewayFrontendIP\",
frontend_port_name = \"httpPort\", protocol = \"Http\" }\]

request_routing_rules = \[{ name = \"rule1\", rule_type = \"Basic\",
http_listener_name = \"httpListener\", backend_address_pool_name =
\"backendPool\", backend_http_settings_name = \"httpSettings\" }\]

probes = \[{ name = \"healthProbe\", protocol = \"Http\", host =
\"10.0.2.4\", path = \"/health\", interval = 30, timeout = 30,
unhealthy_threshold = 3 }\]

enable_waf = true

waf_mode = \"Prevention\"

waf_rule_set_type = \"OWASP\"

waf_rule_set_version = \"3.2\"

waf_disabled_rule_groups = \[

{ rule_group_name = \"REQUEST-942-APPLICATION-ATTACK-SQLI\", rules =
\[\] },

{ rule_group_name = \"REQUEST-941-APPLICATION-ATTACK-XSS\", rules = \[\]
}

\]

waf_disabled_rules = \[942100\]

waf_exclusion_rules = \[{ match_variable = \"RequestHeaderNames\",
selector_match_operator = \"Equals\", selector = \"User-Agent\" }\]

waf_custom_rules = \[{ name = \"BlockBadIPs\", priority = 100, rule_type
= \"MatchRule\", action = \"Block\", match_conditions = \[{
match_variables = \[{ variable_name = \"RemoteAddr\" }\], operator =
\"IPMatch\", values = \[\"192.168.1.1/32\", \"10.0.0.0/8\"\] }\] }\]

}
```
## Azure Storage Account Module

This module creates an Azure Storage Account with specified
configurations, including replication type, access tier, network rules,
and private endpoints. It also configures blob containers, file shares,
queues, and tables.

Example Usage:
```
module \"my_storage_account\" {

source = \"./../storage-account\"

storage_account_name = \"mystorageaccount20250606\"

resource_group_name = module.rg1.resource_group_name

location = module.rg1.resource_group_location

account_tier = \"Standard\"

account_replication_type = \"GRS\"

access_tier = \"Cool\"

is_hns_enabled = false

min_tls_version = \"TLS1_2\"

network_rules_enabled = true

network_rules_default_action = \"Allow\"

network_acl_ip_rules = \[\"1.2.3.8/32\"\]

network_rules_bypass = \[\"AzureServices\"\]

enable_private_endpoint = true

private_endpoint_subnet_id = module.azure_vnet1.subnets_id_wan

private_endpoint_subresource_names = \[\"blob\", \"file\"\]

network_rules_subnet_ids = module.azure_vnet1.subnets_id_wan

blob_containers = \[

{ name = \"app-data\", access_type = \"private\" },

{ name = \"logs\", access_type = \"private\" }

\]

file_shares = \[{ name = \"app-files\", quota = 50 }\]

queues = \[{ name = \"message-queue\" }\]

tables = \[{ name = \"userdata\" }\]
}
```
## Usage

1.  Clone the Repository:

2. git clone \<repository-url\>

3.  cd \<repository-directory\>

4.  Initialize Terraform:

5.  terraform init

This command downloads the necessary providers and modules.

6.  Review the Plan:

7.  terraform plan

This command shows you what resources Terraform will create, modify, or
destroy. Review it carefully to understand the changes.

8.  Apply the Configuration:

9.  terraform apply

Type yes when prompted to confirm the deployment.

## Important Notes

- Variable Management: This configuration uses
  var.resource_group_location, var.environment_name, var.vm_admin,
  var.vm_password, and other variables. Ensure these variables are
  defined in a terraform.tfvars file or passed via the command line for
  your specific environment.

- Secrets Management: Sensitive information like VM credentials (admin
  username/password) are retrieved from HashiCorp Vault using
  data.vault_kv_secret_v2. Ensure your Vault setup is correct,
  accessible, and populated with the necessary secrets.

- Module Source Paths: The source attribute for each module assumes a
  relative path (e.g., ./../rg). Adjust these paths if your directory
  structure differs.

- IP Addresses in ACLs/Probes: Remember to update specific IP addresses
  for network ACLs (e.g., 1.2.3.5/32 in Storage Account and Key
  Vault) and Application Gateway probes (e.g., 10.0.2.4) to match your
  specific environment\'s allowed IPs or backend server IPs.

- Application Gateway SSL Certificate: The ssl_certificates block in the
  Application Gateway module references
  filebase64(\"\${path.module}/cert/1.pfx\"). Ensure your .pfx
  certificate file is present at this exact path relative to the
  module\'s directory.

- WAF Rule Disabling: When disabling WAF rule groups or specific rules,
  ensure you use their exact names/IDs as provided by Azure. Incorrect
  names will not disable the rules.

- Conditional Public IP Creation: The VM module is configured to only
  create Public IP resources when explicitly enabled via the public_ip
  variable for a given VM instance, optimizing cost.

- VM Custom Data Script Paths: Ensure the paths to custom data scripts
  (e.g., for IIS or Ubuntu updates) are correct and accessible by
  Terraform during the plan and apply phases. These paths should be
  relative to where terraform apply is executed or relative to the
  module if path.module is used within the module.
