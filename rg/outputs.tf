output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "Resource group name."
}

output "resource_group_location" {
  value       = azurerm_resource_group.rg.location
  description = "Resource group location."
}