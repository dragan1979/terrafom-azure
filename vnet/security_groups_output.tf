output security_groups_id_wan {
  value = element(concat(azurerm_network_security_group.wan.*.id,  [""]),0)
  description = "Security group WAN ID"
  depends_on = [
    azurerm_subnet.wan,
  ]
}

output security_groups_name_wan {
  value = element(concat(azurerm_network_security_group.wan.*.name,  [""]),0)
  description = "Security group WAN name"
  depends_on = [
    azurerm_subnet.wan,
  ]
}

output security_groups_id_dmz {
  value = element(concat(azurerm_network_security_group.dmz.*.id,  [""]),0)
  description = "Security group DMZ ID"
  depends_on = [
    azurerm_subnet.dmz,
  ]
}

output security_groups_name_dmz {
  value = element(concat(azurerm_network_security_group.dmz.*.name,  [""]),0)
  description = "Security group DMZ name"
  depends_on = [
    azurerm_subnet.dmz,
  ]
}

output security_groups_id_vdi {
  value = element(concat(azurerm_network_security_group.vdi.*.id,  [""]),0)
  description = "Security group VDI ID"
  depends_on = [
    azurerm_subnet.vdi,
  ]
}

output security_groups_name_vdi {
  value = element(concat(azurerm_network_security_group.vdi.*.name,  [""]),0)
  description = "Security group VDI name"
  depends_on = [
    azurerm_subnet.vdi,
  ]
}

output security_groups_id_infrastructure_services {
  value = element(concat(azurerm_network_security_group.infrastructure_services.*.id,  [""]),0)
  description = "Security group Infrastructure services ID"
  depends_on = [
    azurerm_subnet.infrastructure_services,
  ]
}

output security_groups_name_infrastructure_services {
  value = element(concat(azurerm_network_security_group.infrastructure_services.*.name,  [""]),0)
  description = "Security group Infrastructure services name"
  depends_on = [
    azurerm_subnet.infrastructure_services,
  ]
}

output security_groups_id_infrastructure_db_services {
  value = element(concat(azurerm_network_security_group.infrastructure_db_services.*.id,  [""]),0)
  description = "Security group infrastructure DB services ID"
  depends_on = [
    azurerm_subnet.infrastructure_db_services,
  ]
}

output security_groups_name_infrastructure_db_services {
  value = element(concat(azurerm_network_security_group.infrastructure_db_services.*.name,  [""]),0)
  description = "Security group infrastructure DB services name"
  depends_on = [
    azurerm_subnet.infrastructure_db_services,
  ]
}

output security_groups_id_production_app_services {
  value = element(concat(azurerm_network_security_group.production_app_services.*.id,  [""]),0)
  description = "Security group production app services ID"
  depends_on = [
    azurerm_subnet.production_app_services,
  ]
}

output security_groups_name_production_app_services {
  value = element(concat(azurerm_network_security_group.production_app_services.*.name,  [""]),0)
  description = "Security group production app services name"
  depends_on = [
    azurerm_subnet.production_app_services,
  ]
}

output security_groups_id_production_db_services {
  value = element(concat(azurerm_network_security_group.production_db_services.*.id,  [""]),0)
  description = "Security group production DB services ID"
  depends_on = [
    azurerm_subnet.production_db_services,
  ]
}

output security_groups_name_production_db_services {
  value = element(concat(azurerm_network_security_group.production_db_services.*.name,  [""]),0)
  description = "Security group production DB services name"
  depends_on = [
    azurerm_subnet.production_db_services,
  ]
}

output security_groups_id_acceptance_app_services {
  value = element(concat(azurerm_network_security_group.acceptance_app_services.*.id,  [""]),0)
  description = "Security group acceptance app services ID"
  depends_on = [
    azurerm_subnet.acceptance_app_services,
  ]
}

output security_groups_name_acceptance_app_services {
  value = element(concat(azurerm_network_security_group.acceptance_app_services.*.name,  [""]),0)
  description = "Security group acceptance app services name"
  depends_on = [
    azurerm_subnet.acceptance_app_services,
  ]
}

output security_groups_id_acceptance_db_services {
  value = element(concat(azurerm_network_security_group.acceptance_db_services.*.id,  [""]),0)
  description = "Security group acceptance DB services ID"
  depends_on = [
    azurerm_subnet.acceptance_db_services,
  ]
}

output security_groups_name_acceptance_db_services {
  value = element(concat(azurerm_network_security_group.acceptance_db_services.*.name,  [""]),0)
  description = "Security group acceptance DB services name"
  depends_on = [
    azurerm_subnet.acceptance_db_services,
  ]
}

output security_groups_id_test_app_services {
  value = element(concat(azurerm_network_security_group.test_app_services.*.id,  [""]),0)
  description = "Security group test app services ID"
  depends_on = [
    azurerm_subnet.test_app_services,
  ]
}

output security_groups_name_test_app_services {
  value = element(concat(azurerm_network_security_group.test_app_services.*.name,  [""]),0)
  description = "Security group test app services name"
  depends_on = [
    azurerm_subnet.test_app_services,
  ]
}

output security_groups_id_test_db_services {
  value = element(concat(azurerm_network_security_group.test_db_services.*.id,  [""]),0)
  description = "Security group test DB services ID"
  depends_on = [
    azurerm_subnet.test_db_services,
  ]
}

output security_groups_name_test_db_services {
  value = element(concat(azurerm_network_security_group.test_db_services.*.name,  [""]),0)
  description = "Security group test DB services name"
  depends_on = [
    azurerm_subnet.test_db_services,
  ]
}

output security_groups_id_development_app_services {
  value = element(concat(azurerm_network_security_group.development_app_services.*.id,  [""]),0)
  description = "Security group development app services ID"
  depends_on = [
    azurerm_subnet.development_app_services,
  ]
}

output security_groups_name_development_app_services {
  value = element(concat(azurerm_network_security_group.development_app_services.*.name,  [""]),0)
  description = "Security group development app services name"
  depends_on = [
    azurerm_subnet.development_app_services,
  ]
}

output security_groups_id_development_db_services {
  value = element(concat(azurerm_network_security_group.development_db_services.*.id,  [""]),0)
  description = "Security group development DB services ID"
  depends_on = [
    azurerm_subnet.development_db_services,
  ]
}

output security_groups_name_development_db_services {
  value = element(concat(azurerm_network_security_group.development_db_services.*.name,  [""]),0)
  description = "Security group development DB services name"
  depends_on = [
    azurerm_subnet.development_db_services,
  ]
}