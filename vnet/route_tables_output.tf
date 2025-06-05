output route_tables_id_wan {
  value = element(concat(azurerm_route_table.wan.*.id,  [""]),0)
  description = "Route table WAN ID"

  depends_on = [
    azurerm_route_table.wan,
  ]
}

output route_tables_name_wan {
  value = element(concat(azurerm_route_table.wan.*.name,  [""]),0)
  description = "Route table WAN name"

  depends_on = [
    azurerm_route_table.wan,
  ]
}

output route_tables_id_dmz {
  value = element(concat(azurerm_route_table.dmz.*.id,  [""]),0)
  description = "Route table DMZ ID"

  depends_on = [
    azurerm_route_table.dmz,
  ]
}

output route_tables_name_dmz {
   value = element(concat(azurerm_route_table.dmz.*.name,  [""]),0)
  description = "Route tablle DMZ name"
  depends_on = [
    azurerm_route_table.dmz,
  ]
}

output route_tables_id_vdi {
  value = element(concat(azurerm_route_table.vdi.*.id,  [""]),0)
  description = "Route table VDI ID"
  depends_on = [
    azurerm_route_table.vdi,
  ]
}

output route_tables_name_vdi {
  value = element(concat(azurerm_route_table.vdi.*.name,  [""]),0)
  description = "Route table VDI name"
  depends_on = [
    azurerm_route_table.vdi,
  ]
}

output route_tables_id_infrastructure_services {
  value = element(concat(azurerm_route_table.infrastructure_services.*.id,  [""]),0)
  description = "Route table infrastructure service ID"

  depends_on = [
    azurerm_route_table.infrastructure_services,
  ]
}

output route_tables_name_infrastructure_services {
  value = element(concat(azurerm_route_table.infrastructure_services.*.name,  [""]),0)
  description = "Route table infrastructure service name"
  depends_on = [
    azurerm_route_table.infrastructure_services,
  ]
}

output route_tables_id_infrastructure_db_services {
  value = element(concat(azurerm_route_table.infrastructure_db_services.*.id,  [""]),0)
  description = "Route table Infrastructure DB service ID"
  depends_on = [
    azurerm_route_table.infrastructure_db_services,
  ]
}

output route_tables_name_infrastructure_db_services {
  value = element(concat(azurerm_route_table.infrastructure_services.*.name,  [""]),0)
  description = "Route table Infrastructure DB service name"
  depends_on = [
    azurerm_route_table.infrastructure_db_services,
  ]
}

output route_tables_id_production_app_services {
  value = element(concat(azurerm_route_table.production_app_services.*.id,  [""]),0)
  description = "Route table production app services ID"
  depends_on = [
    azurerm_route_table.production_app_services,
  ]
}

output route_tables_name_production_app_services {
  value = element(concat(azurerm_route_table.production_app_services.*.name,  [""]),0)
  description = "Route table production app services name"
  depends_on = [
    azurerm_route_table.production_app_services,
  ]
}

output route_tables_id_production_db_services {
  value = element(concat(azurerm_route_table.production_db_services.*.id,  [""]),0)
  description = "Route table production DB services ID"
  depends_on = [
    azurerm_route_table.production_db_services,
  ]
}

output route_tables_name_production_db_services {
  value = element(concat(azurerm_route_table.production_db_services.*.name,  [""]),0)
  description = "Route table production DB services name"
  depends_on = [
    azurerm_route_table.production_db_services,
  ]
}

output route_tables_id_acceptance_app_services {
  value = element(concat(azurerm_route_table.acceptance_app_services.*.id,  [""]),0)
  description = "Route table acceptance app services ID"
  depends_on = [
    azurerm_route_table.acceptance_app_services,
  ]
}

output route_tables_name_acceptance_app_services {
  value = element(concat(azurerm_route_table.acceptance_app_services.*.name,  [""]),0)
  description = "Route table acceptance app services name" 
  depends_on = [
    azurerm_route_table.acceptance_app_services,
  ]
}

output route_tables_id_acceptance_db_services {
  value = element(concat(azurerm_route_table.acceptance_db_services.*.id,  [""]),0)
  description = "Route table acceptance DB services ID"
  depends_on = [
    azurerm_route_table.acceptance_db_services,
  ]
}

output route_tables_name_acceptance_db_services {
  value = element(concat(azurerm_route_table.acceptance_db_services.*.name,  [""]),0)
  description = "Route table acceptance DB services name"
  depends_on = [
    azurerm_route_table.acceptance_db_services,
  ]
}

output route_tables_id_test_app_services {
  value = element(concat(azurerm_route_table.test_app_services.*.id,  [""]),0)
  description = "Route table test app services ID"
  depends_on = [
    azurerm_route_table.test_app_services,
  ]
}

output route_tables_name_test_app_services {
  value = element(concat(azurerm_route_table.test_app_services.*.name,  [""]),0)
  description = "Route table test app services name"
  depends_on = [
    azurerm_route_table.test_app_services,
  ]
}

output route_tables_id_test_db_services {
  value = element(concat(azurerm_route_table.test_db_services.*.id,  [""]),0)
  description = "Route table test DB services ID"
  depends_on = [
    azurerm_route_table.test_db_services,
  ]
}

output route_tables_name_test_db_services {
  value = element(concat(azurerm_route_table.test_db_services.*.name,  [""]),0)
  description = "Route table test DB services name"
  depends_on = [
    azurerm_route_table.test_db_services,
  ]
}

output route_tables_id_development_app_services {
  value = element(concat(azurerm_route_table.development_app_services.*.id,  [""]),0)
  description = "Route table development app services ID"
  depends_on = [
    azurerm_route_table.development_app_services,
  ]
}

output route_tables_name_development_app_services {
  value = element(concat(azurerm_route_table.development_app_services.*.name,  [""]),0)
  description = "Route table development app services name"
  depends_on = [
    azurerm_route_table.development_app_services,
  ]
}

output route_tables_id_development_db_services {
  value = element(concat(azurerm_route_table.development_db_services.*.id,  [""]),0)
  description = "Route tables development DB services ID"
  depends_on = [
    azurerm_route_table.development_db_services,
  ]
}

output route_tables_name_development_db_services {
  value = element(concat(azurerm_route_table.development_db_services.*.name,  [""]),0)
  description = "Route tables development DB services name"
  depends_on = [
    azurerm_route_table.development_db_services,
  ]
}

output route_tables_id_gateway {
  value = element(concat(azurerm_route_table.gateway.*.id,  [""]),0)
  description = "Route table gateway ID"
  depends_on = [
    azurerm_route_table.gateway,
  ]
}

output route_tables_name_gateway {
  value = element(concat(azurerm_route_table.gateway.*.name,  [""]),0)
  description = "Route table gateway name"
  depends_on = [
    azurerm_route_table.gateway,
  ]
}