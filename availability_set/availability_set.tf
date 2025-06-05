#Availability Set

resource "azurerm_availability_set" "this" {

  name                           = format("%s-%s", var.environment_name, "Availability_Set")
  location                       = var.resource_group_location
  resource_group_name            = var.resource_group_name
  platform_update_domain_count   = var.availability_set_update_domain_count
  platform_fault_domain_count    = var.availability_set_fault_domain_count
  managed                        = var.availability_set_managed
  tags                           = merge({Name = format("%s-%s", var.environment_name, "Availability_Set")})
}
