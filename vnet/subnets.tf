### SubnetAZ: WAN ###
resource "azurerm_subnet" "wan" {
  count = var.enable_wan_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "WAN", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 1)]
  service_endpoints          = compact([var.enable_wan_storage_endpoint ? "Microsoft.Storage" : ""])
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
}

### Subnet: DMZ ###
resource "azurerm_subnet" "dmz" {
  count = var.enable_dmz_subnet ? 1 : 0
  name                      = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "DMZ", "Subnet")
  virtual_network_name      = azurerm_virtual_network.this.name
  resource_group_name       = var.resource_group_name
  address_prefixes          = [cidrsubnet(var.cidr_block, 5, count.index + 2)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_dmz_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: VDI ###
resource "azurerm_subnet" "vdi" {
  count = var.enable_vdi_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "VDI", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 4)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_vdi_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Infrastructure Services ###
resource "azurerm_subnet" "infrastructure_services" {

  count = var.enable_infrastructure_services_subnet ? 1 : 0

  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 6)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_infrastructure_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Infrastructure DB Services ###
resource "azurerm_subnet" "infrastructure_db_services" {
  count = var.enable_infrastructure_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-DB-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 8)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_infrastructure_db_services_storage_endpoint ? "Microsoft.Storage" : ""])
  
}

### Subnet: Production App Services ###
resource "azurerm_subnet" "production_app_services" {
  count = var.enable_production_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-App-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 10)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_production_app_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Production DB Services ###
resource "azurerm_subnet" "production_db_services" {
  count = var.enable_production_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-DB-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 12)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_production_db_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Acceptance App Services ###
resource "azurerm_subnet" "acceptance_app_services" {
  count = var.enable_acceptance_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, "Acceptance-App-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 14)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_acceptance_app_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Accpetance DB Services ###
resource "azurerm_subnet" "acceptance_db_services" {
  count = var.enable_acceptance_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-DB-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 16)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_acceptance_db_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Test App Services ###
resource "azurerm_subnet" "test_app_services" {
  count = var.enable_test_app_services_subnet ? 1 : 0

  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-App-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 ,count.index + 18)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_test_app_services_storage_endpoint ? "Microsoft.Storage" : ""])
  
}

### Subnet: Test DB Services ###
resource "azurerm_subnet" "test_db_services" {
  count = var.enable_test_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-DB-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 20)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_test_db_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Development App Services ###
resource "azurerm_subnet" "development_app_services" {
  count = var.enable_development_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-App-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5 , count.index + 22)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_development_app_services_storage_endpoint ? "Microsoft.Storage" : ""])
}

### Subnet: Development DB Services ###
resource "azurerm_subnet" "development_db_services" {
  count = var.enable_development_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-DB-Services", "Subnet")
  virtual_network_name       = azurerm_virtual_network.this.name
  resource_group_name        = var.resource_group_name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 24)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_development_app_services_storage_endpoint ? "Microsoft.Storage" : ""])
 
}

### Subnet: Gateway ###
resource "azurerm_subnet" "gateway" {
  count                      = var.enable_gateway_subnet ? 1 : 0
  name                       = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Gateway", "Subnet")          
  resource_group_name        = var.resource_group_name
  virtual_network_name       = azurerm_virtual_network.this.name
  address_prefixes           = [cidrsubnet(var.cidr_block, 5, count.index + 26)]
  #lifecycle {ignore_changes = [route_table_id, network_security_group_id]}
  service_endpoints          = compact([var.enable_gateway_storage_endpoint ? "Microsoft.Storage" : ""])
}