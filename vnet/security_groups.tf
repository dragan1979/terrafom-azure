### Security Group: WAN ####

resource "azurerm_network_security_group" "wan" {
  count = var.enable_wan_subnet ? 1 : 0
  name                      = format("%s-%s-%s", var.environment_name, var.vnet_name, "WAN-Subnet-Security-Group")
  location                  = var.resource_group_location
  resource_group_name       = var.resource_group_name
  
  tags                      = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "WAN-Subnets", "Security-Group")
    }, 
      var.tags_module,
      var.tags_global
    )
  }
     

resource "azurerm_subnet_network_security_group_association" "wan" {
  count = var.enable_wan_subnet ? 1 : 0
  subnet_id                 = element(azurerm_subnet.wan.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.wan.*.id, count.index)
  
}

### Security Group: DMZ ####

resource "azurerm_network_security_group" "dmz" {
  count                      = var.enable_dmz_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "DMZ-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({  
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "DMZ-Subnets", "Security-Group")  
  }, 
  var.tags_module,
  var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "dmz" {
  count                      = var.enable_dmz_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.dmz.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.dmz.*.id, count.index)
}

### Security Group: VDI ####
resource "azurerm_network_security_group" "vdi" {
  count = var.enable_vdi_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "VDI-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "VDI-Subnets", "Security-Group")
  }, 
  var.tags_module,
  var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "vdi" {
  count                      = var.enable_vdi_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.vdi.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.vdi.*.id, count.index)
}

### Security Group: Infrastructure Services ####
resource "azurerm_network_security_group" "infrastructure_services" {
  count = var.enable_infrastructure_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "infrastructure_services" {
  count                      = var.enable_infrastructure_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.infrastructure_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.infrastructure_services.*.id, count.index)
}

### Security Group: Infrastructure DB Services ####
resource "azurerm_network_security_group" "infrastructure_db_services" {
  count = var.enable_infrastructure_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-DB-services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Infrastructure-DB-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "infrastructure_db_services" {
  count = var.enable_infrastructure_db_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.infrastructure_db_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.infrastructure_db_services.*.id, count.index)
}

### Security Group: Production App Services ####
resource "azurerm_network_security_group" "production_app_services" {
  count                      = var.enable_production_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Production-App-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-App-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "production_app_services" {
  count                      = var.enable_production_app_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.production_app_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.production_app_services.*.id, count.index)
}

### Security Group: Production DB Services ####
resource "azurerm_network_security_group" "production_db_services" {
  count = var.enable_production_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Production-DB-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags                       = merge({ 
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Production-DB-Services-Subnets", "Security-Group")
  },
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "production_db_services" {
  count = var.enable_production_db_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.production_db_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.production_db_services.*.id, count.index)
}

### Security Group: Acceptance App Services ####
resource "azurerm_network_security_group" "acceptance_app_services" {
  count = var.enable_acceptance_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-App-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-App-Services-Subnets", "Security-Group")
  },
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "acceptance_app_services" {
  count = var.enable_acceptance_app_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.acceptance_app_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.acceptance_app_services.*.id, count.index)
}

### Security Group: Acceptance DB Services ####
resource "azurerm_network_security_group" "acceptance_db_services" {
  count = var.enable_acceptance_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-DB-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({      
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Acceptance-DB-Services-Subnets", "Security-Group")
  },
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "acceptance_db_services" {
  count                      = var.enable_acceptance_db_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.acceptance_db_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.acceptance_db_services.*.id, count.index)
}

### Security Group: Test App Services ####
resource "azurerm_network_security_group" "test_app_services" {
  count                      = var.enable_test_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Test-App-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
          "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-App-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "test_app_services" {
  count                      = var.enable_test_app_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.test_app_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.test_app_services.*.id, count.index)
}

### Security Group: Test DB Services ####
resource "azurerm_network_security_group" "test_db_services" {
  count = var.enable_test_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Test-DB-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Test-DB-Services-Subnets", "Security-Group") 
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "test_db_services" {
  count                      = var.enable_test_db_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.test_db_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.test_db_services.*.id, count.index)
}

### Security Group: Development App Services ####
resource "azurerm_network_security_group" "development_app_services" {
  count = var.enable_development_app_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Development-App-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-App-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "development_app_services" {
  count                      = var.enable_development_app_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.development_app_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.development_app_services.*.id, count.index)
}

### Security Group: Development DB Services ####
resource "azurerm_network_security_group" "development_db_services" {
  count                      = var.enable_development_db_services_subnet ? 1 : 0
  name                       = format("%s-%s-%s", var.environment_name, var.vnet_name, "Development-DB-Services-Subnet-Security-Group")
  location                   = var.resource_group_location
  resource_group_name        = var.resource_group_name

  tags                       = merge({
      "Name" = format("%s-%s-%s-%s", var.environment_name, var.vnet_name, "Development-DB-Services-Subnets", "Security-Group")
  }, 
      var.tags_module,
      var.tags_global
    )
}

resource "azurerm_subnet_network_security_group_association" "development_db_services" {
  count                      = var.enable_development_db_services_subnet ? 1 : 0
  subnet_id                  = element(azurerm_subnet.development_db_services.*.id, count.index)
  network_security_group_id  = element(azurerm_network_security_group.development_db_services.*.id, count.index)
}