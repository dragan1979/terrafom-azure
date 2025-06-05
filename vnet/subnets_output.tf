output subnets_id_wan {
  value = element(concat(azurerm_subnet.wan.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.wan,
  ]
}

output subnets_cidr_block_wan {
  value = element(concat(azurerm_subnet.wan.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.wan,
  ]
}

output subnets_id_dmz {
  value = element(concat(azurerm_subnet.dmz.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.dmz,
  ]
}

output subnets_cidr_block_dmz {
  value = element(concat(azurerm_subnet.dmz.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.dmz,
  ]
}

output subnets_id_vdi {
  value = element(concat(azurerm_subnet.vdi.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.vdi,
  ]
}

output subnets_cidr_block_vdi {
  value =element(concat(azurerm_subnet.vdi.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.vdi,
  ]
}

output subnets_id_infrastructure_services {
  value = element(concat(azurerm_subnet.infrastructure_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.infrastructure_services,
  ]
}

output subnets_cidr_block_infrastructure_services {
  value = element(concat(azurerm_subnet.infrastructure_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.infrastructure_services,
  ]
}

output subnets_id_infrastructure_db_services {
  value = element(concat(azurerm_subnet.infrastructure_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.infrastructure_db_services,
  ]
}

output subnets_cidr_block_infrastructure_db_services {
  value = element(concat(azurerm_subnet.infrastructure_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.infrastructure_db_services,
  ]
}

output subnets_id_production_app_services {
  value = element(concat(azurerm_subnet.production_app_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.production_app_services,
  ]
}

output subnets_cidr_block_production_app_services {
  value = element(concat(azurerm_subnet.production_app_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.production_app_services,
  ]
}

output subnets_id_production_db_services {
  value = element(concat(azurerm_subnet.production_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.production_db_services,
  ]
}

output subnets_cidr_block_production_db_services {
  value = element(concat(azurerm_subnet.production_db_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.production_db_services,
  ]
}

output subnets_id_acceptance_app_services {
  value = element(concat(azurerm_subnet.acceptance_app_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.acceptance_app_services,
  ]
}

output subnets_cidr_block_acceptance_app_services {
  value = element(concat(azurerm_subnet.acceptance_app_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.acceptance_app_services,
  ]
}

output subnets_id_acceptance_db_services {
  value = element(concat(azurerm_subnet.acceptance_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.acceptance_db_services,
  ]
}

output subnets_cidr_block_acceptance_db_services {
  value = element(concat(azurerm_subnet.acceptance_db_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.acceptance_db_services,
  ]
}

output subnets_id_test_app_services {
  value = element(concat(azurerm_subnet.test_app_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.test_app_services,
  ]
}

output subnets_cidr_block_test_app_services {
  value = element(concat(azurerm_subnet.test_app_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.test_app_services,
  ]
}

output subnets_id_test_db_services {
  value = element(concat(azurerm_subnet.test_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.test_db_services,
  ]
}

output subnets_cidr_block_test_db_services {
  value = element(concat(azurerm_subnet.test_db_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.test_db_services,
  ]
}

output subnets_id_development_app_services {
  value = element(concat(azurerm_subnet.development_app_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.development_app_services,
  ]
}

output subnets_cidr_block_development_app_services {
  value = element(concat(azurerm_subnet.development_app_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.development_app_services,
  ]
}

output subnets_id_development_db_services {
  value = element(concat(azurerm_subnet.development_db_services.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.development_db_services,
  ]
}

output subnets_cidr_block_development_db_services {
  value = element(concat(azurerm_subnet.development_db_services.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.development_db_services,
  ]
}

output subnets_id_gateway {
  value = element(concat(azurerm_subnet.gateway.*.id,  [""]),0)

  depends_on = [
    azurerm_subnet.gateway,
  ]
}

output subnets_cidr_block_gateway {
  value = element(concat(azurerm_subnet.gateway.*.address_prefixes,  [""]),0)

  depends_on = [
    azurerm_subnet.gateway,
  ]
}