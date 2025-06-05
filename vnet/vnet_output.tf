output "vnet_id" {
  value = azurerm_virtual_network.this.id
  description = "Virtual network ID"
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name # Assuming 'this' is the name of your azurerm_virtual_network resource
}

output "region_name" {
  value = var.resource_group_location
  description = "Region name"
}

output "environment_name" {
  value = var.environment_name
  description = "Environment name"
}

output "vnet_cidr_block" {
  value       = azurerm_virtual_network.this.address_space
  description = "The CIDR block of the VNET"
}

output "environment_type" {
  value = lower(var.environment_type)
  description = "Environment type"
}