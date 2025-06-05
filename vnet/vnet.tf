resource "azurerm_virtual_network" "this" {
  name                = format("%s-%s-%s", var.environment_name, var.vnet_name, "VNET")
  location            = var.resource_group_location
  address_space       = [var.cidr_block]
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers

  tags = merge({
  Name = format("%s-%s-%s", var.environment_name, var.vnet_name, "VNET")
  },
    var.tags_module,
    var.tags_global
    )
}