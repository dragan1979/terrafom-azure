### Route Table: WAN ####
resource "azurerm_route_table" "wan" {
  
  count = var.enable_wan_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "WAN", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true
  tags                          = merge(
  {
    Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "WAN", "RouteTable")
  }, var.tags_module,
  var.tags_global
  )
  
}

resource "azurerm_subnet_route_table_association" "wan" {

  count                         = var.enable_wan_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.wan.*.id, count.index)
  route_table_id                = element(azurerm_route_table.wan.*.id, count.index)
  
}

### Route Table: DMZ ####
resource "azurerm_route_table" "dmz" {
  count = var.enable_dmz_subnet ? 1 : 0

  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "DMZ", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge(
  {
    Name = format("%s-%s-%s-%s",var.environment_name, var.vnet_name, "DMZ","RouteTable")
  }, var.tags_module, var.tags_global
  )
}



resource "azurerm_subnet_route_table_association" "dmz" {
  count = var.enable_dmz_subnet ? 1 : 0 
  subnet_id                     = element(azurerm_subnet.dmz.*.id, count.index)
  route_table_id                = element(azurerm_route_table.dmz.*.id, count.index)
}

### Route Table: VDI ####
resource "azurerm_route_table" "vdi" {
  count = var.enable_vdi_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "VDI", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          =  merge(
  {
  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "VDI", "RouteTable")
  }, var.tags_module, var.tags_global
  ) 
}

resource "azurerm_subnet_route_table_association" "vdi" {
  count = var.enable_vdi_subnet ? 1 : 0 
  subnet_id                     = element(azurerm_subnet.vdi.*.id, count.index)
  route_table_id                = element(azurerm_route_table.vdi.*.id, count.index)
}

### Route Table: Infrastructure Services ####
resource "azurerm_route_table" "infrastructure_services" {
  count = var.enable_infrastructure_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge(
  {  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-Services", "RouteTable")
  }, var.tags_module, var.tags_global
  )
}

resource "azurerm_subnet_route_table_association" "infrastructure_services" {
  count = var.enable_infrastructure_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.infrastructure_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.infrastructure_services.*.id, count.index)
}

### Route Table: Infrastructure DB Services ####
resource "azurerm_route_table" "infrastructure_db_services" {
  count = var.enable_infrastructure_db_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-DB-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge(
    {
    Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-DB-Services", "RouteTable")
    }, var.tags_module,
  var.tags_global
  )
  
  
}

resource "azurerm_subnet_route_table_association" "infrastructure_db_services" {
  count                         = var.enable_infrastructure_db_services_subnet ? 1 : 0 
  subnet_id                     = element(azurerm_subnet.infrastructure_db_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.infrastructure_db_services.*.id, count.index)
}

### Route Table: Production App Services ####
resource "azurerm_route_table" "production_app_services" {
  count = var.enable_production_app_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-App-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge(
    {
    Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-App-Services", "RouteTable")
    },
  var.tags_module,
  var.tags_global
  )
  
  
}

resource "azurerm_subnet_route_table_association" "production_app_services" {
  count                         = var.enable_production_app_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.production_app_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.production_app_services.*.id, count.index)
}

### Route Table: Production DB Services ####
resource "azurerm_route_table" "production_db_services" {
  count                         = var.enable_production_db_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-DB-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
    Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-DB-Services", "RouteTable")
  },
  var.tags_module,
  var.tags_global
  )
  
}

resource "azurerm_subnet_route_table_association" "production_db_services" {
  count                         = var.enable_production_db_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.production_db_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.production_db_services.*.id, count.index)
}

### Route Table: Acceptance App Services ####
resource "azurerm_route_table" "acceptance_app_services" {
  count = var.enable_acceptance_app_services_subnet ? 1 : 0

  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-App-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-App-Services", "RouteTable")
  },
  var.tags_module,
  var.tags_global)
}

resource "azurerm_subnet_route_table_association" "acceptance_app_services" {
  count                         = var.enable_acceptance_app_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.acceptance_app_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.acceptance_app_services.*.id, count.index)
}

### Route Table: Acceptance DB Services ####
resource "azurerm_route_table" "acceptance_db_services" {
  count = var.enable_acceptance_db_services_subnet ? 1 : 0
  
  name                          = format("%s-%s-%s", var.environment_name, "Acceptance-DB-services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-DB-Services", "RouteTable")
  }, var.tags_module, var.tags_global)
}

resource "azurerm_subnet_route_table_association" "acceptance_db_services" {
  count                         = var.enable_acceptance_db_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.acceptance_db_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.acceptance_db_services.*.id, count.index)
}

### Route Table: Test App Services ####
resource "azurerm_route_table" "test_app_services" {
  count = var.enable_test_app_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-App-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-App-Services", "RouteTable")
  },var.tags_module,
  var.tags_global
  )
}

resource "azurerm_subnet_route_table_association" "test_app_services" {
  count                         = var.enable_test_app_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.test_app_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.test_app_services.*.id, count.index)
}

### Route Table: Test DB Services ####
resource "azurerm_route_table" "test_db_services" {
  count = var.enable_test_db_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-DB-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
  Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-DB-Services", "RouteTable")
  }, 
  var.tags_module,
  var.tags_global
  )
}

resource "azurerm_subnet_route_table_association" "test_db_services" {
  count                         = var.enable_test_db_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.test_db_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.test_db_services.*.id, count.index)
}

### Route Table: Development App Services ####
resource "azurerm_route_table" "development_app_services" {
  count = var.enable_development_app_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-App-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
       Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-App-Services", "RouteTable")
  } ,
  var.tags_module,
  var.tags_global
  )
  
}

resource "azurerm_subnet_route_table_association" "development_app_services" {
  count                         = var.enable_development_app_services_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.development_app_services.*.id, count.index)
  route_table_id                = element(azurerm_route_table.development_app_services.*.id, count.index)
}

### Route Table: Development DB Services ####
resource "azurerm_route_table" "development_db_services" {
  count                         = var.enable_development_db_services_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name,  "Development-DB-Services", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({
   Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-DB-Services", "RouteTable")
  },
  var.tags_module,
  var.tags_global
  )
}

resource "azurerm_subnet_route_table_association" "development_db_services" {
  count = var.enable_development_db_services_subnet ? 1 : 0
  subnet_id      = element(azurerm_subnet.development_db_services.*.id, count.index)
  route_table_id = element(azurerm_route_table.development_db_services.*.id, count.index)
}

### Route Table: Gateway ####
resource "azurerm_route_table" "gateway" {
  count = var.enable_gateway_subnet ? 1 : 0
  name                          = format("%s-%s-%s-%s", var.environment_name, var.vnet_name,  "Gateway", "RouteTable")
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags                          = merge({ 
    Name = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Gateway", "RouteTable")
  },
  var.tags_module,
  var.tags_global
  )
}

resource "azurerm_subnet_route_table_association" "gateway" {
  count                         = var.enable_gateway_subnet ? 1 : 0
  subnet_id                     = element(azurerm_subnet.gateway.*.id, count.index)
  route_table_id                = element(azurerm_route_table.gateway.*.id, count.index)
}