resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = format("%s-to-%s-peering", var.vnet1_name, var.vnet2_name)
  resource_group_name       = var.vnet1_rg_name
  virtual_network_name      = var.vnet1_name
  remote_virtual_network_id = var.vnet2_id

  # Access settings (adjust based on your requirements)
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false # Typically set to true if you route traffic through NVA in one VNet
  allow_gateway_transit        = false # Set to true if a gateway in VNET1 should be used by VNET2
  use_remote_gateways          = false # Set to true if VNET1 should use VNET2's gateway (only one side can be true)

  # Explicitly declare dependencies to ensure VNets are created first
  depends_on = [
    var.vnet1_id, # Depends on the VNETs actually being created
    var.vnet2_id,
  ]
}

resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = format("%s-to-%s-peering", var.vnet2_name, var.vnet1_name)
  resource_group_name       = var.vnet2_rg_name
  virtual_network_name      = var.vnet2_name
  remote_virtual_network_id = var.vnet1_id

  # Access settings (adjust based on your requirements)
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false # Set to true if a gateway in VNET2 should be used by VNET1
  use_remote_gateways          = false # Set to true if VNET2 should use VNET1's gateway (only one side can be true)

  # Explicitly declare dependencies
  depends_on = [
    var.vnet1_id,
    var.vnet2_id,
  ]
}