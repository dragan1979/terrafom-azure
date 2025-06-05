### Security Group: WAN - rules ####

resource "azurerm_network_security_rule" "example" {
  count                       = var.enable_wan_subnet ? 1 : 0
  name                        = format("%s-%s-%s", var.environment_name, var.vnet_name, "WAN-Subnet-Security-Rule")
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.wan[count.index].name
}