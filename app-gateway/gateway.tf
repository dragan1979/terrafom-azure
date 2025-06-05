resource "azurerm_application_gateway" "this" {
  name                = format("%s-%s-%s", var.environment_name, var.app-gateway-name, "APP-Gateway")
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_tier
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = var.subnet_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                     = frontend_ip_configuration.value.name
      public_ip_address_id     = var.create_public_ip ? azurerm_public_ip.gateway_public_ip[0].id : lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
      private_ip_address       = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", "Dynamic")
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_port_configurations
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                        = backend_http_settings.value.name
      cookie_based_affinity                       = backend_http_settings.value.cookie_based_affinity
      port                                        = backend_http_settings.value.port
      protocol                                    = backend_http_settings.value.protocol
      request_timeout                             = backend_http_settings.value.request_timeout
      probe_name                                  = lookup(backend_http_settings.value, "probe_name", null)
      host_name                                   = lookup(backend_http_settings.value, "host_name", null)
      pick_host_name_from_backend_address         = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", null)
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      host_name                      = lookup(http_listener.value, "host_name", null)
      require_sni                    = lookup(http_listener.value, "require_sni", null)
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = request_routing_rule.value.rule_type
      http_listener_name          = request_routing_rule.value.http_listener_name
     priority                     = lookup(request_routing_rule.value, "priority", 100) 
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name", null)
      url_path_map_name           = lookup(request_routing_rule.value, "url_path_map_name", null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name", null)
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name                = probe.value.name
      protocol            = probe.value.protocol
      path                = probe.value.path
      interval            = probe.value.interval
      timeout             = probe.value.timeout
      unhealthy_threshold = probe.value.unhealthy_threshold
      host                = lookup(probe.value, "host", null)

     
      match {
        body        = lookup(probe.value, "match_body", null)
        status_code = lookup(probe.value, "match_status_code", ["200"]) # Fixed: singular and provide default
      }
    }
  }

    dynamic "ssl_certificate" {
        for_each = var.ssl_certificates
        content {
          name     = ssl_certificate.value.name
          data     = ssl_certificate.value.data
          password = ssl_certificate.value.password
        }
      }

  # Conditional WAF Configuration
  dynamic "waf_configuration" {
    for_each = var.enable_waf ? ["waf"] : []
    content {
      enabled        = true
      firewall_mode  = var.waf_mode
      rule_set_type  = var.waf_rule_set_type
      rule_set_version = var.waf_rule_set_version

      dynamic "disabled_rule_group" {
        for_each = var.waf_disabled_rule_groups
        content {
          rule_group_name = disabled_rule_group.value.rule_group_name
          rules           = lookup(disabled_rule_group.value, "rules", null)
        }
      }

      dynamic "exclusion" {
        for_each = var.waf_exclusion_rules
        content {
          match_variable        = exclusion.value.match_variable
          selector_match_operator = exclusion.value.selector_match_operator
          selector              = exclusion.value.selector
        }
      }
    
    }
  }

  tags = merge({ Name = format("%s-%s-%s", var.environment_name, var.app-gateway-name, "App-Gateway")
  }, var.tags_module, var.tags_global
  )
}

resource "azurerm_public_ip" "gateway_public_ip" {
  # This makes the public IP creation optional based on var.create_public_ip
  count = var.create_public_ip ? 1 : 0

  name                = format("%s-%s-%s", var.environment_name, var.app-gateway-name, "App-Gateway-Public-IP") # Using var.app_gateway_name
  location            = var.location # Use var.location from the module
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method # Use new variable
  sku                 = var.public_ip_sku               # Use new variable
  zones               = var.public_ip_zones             # Use new variable

  tags = merge({
    Name = format("%s-%s-%s", var.environment_name, var.app-gateway-name, "App-Gateway-Public-IP") # Using var.app_gateway_name
  },
    var.tags_module,
    var.tags_global
  )
}
