# Create a Public IP for the Load Balancer Frontend
# Create a Public IP for the Load Balancer Frontend
resource "azurerm_public_ip" "lb_public_ip" {
  name                = format("%s-%s-%s", var.environment_name, var.lb_name_suffix, "Public-IP")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku
  zones               = var.availability_zone
    tags = merge({
    Name = format("%s-%s-%s", var.environment_name, var.lb_name_suffix, "Public-IP")
  },
    var.tags_module,
    var.tags_global
  )
}

# Create the Azure Load Balancer
resource "azurerm_lb" "main" {
  name                = format("%s-%s", var.load_balancer_name, "LB")
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    # This name "LoadBalancerFrontend" is hardcoded and consistent with how rules refer to it.
    # If you need multiple frontends, you'd convert this to a dynamic block.
    name                 = "LoadBalancerFrontend"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }
  tags = merge({
    Name = format("%s-%s-%s", var.environment_name, var.lb_name_suffix, "LB")
  },
    var.tags_module,
    var.tags_global
  )
}

# Create a Backend Address Pool
resource "azurerm_lb_backend_address_pool" "main" {
  name            = format("%s-%s-%s", var.environment_name, var.lb_name_suffix, "Backend-Pool")
  loadbalancer_id = azurerm_lb.main.id
}  


resource "azurerm_lb_probe" "probes" { # Renamed to 'probes' for clarity
  for_each = var.probes # Use the 'probes' variable (map of objects)

  name                = format("%s-%s-%s-%s", var.environment_name, var.lb_name_suffix, "Probe", each.key)
  protocol            = each.value.protocol
  port                = each.value.port
  interval_in_seconds = lookup(each.value, "interval_in_seconds", 5)
  number_of_probes    = lookup(each.value, "number_of_probes", 2)
  request_path        = lookup(each.value, "request_path", null)
  loadbalancer_id     = azurerm_lb.main.id
  
}

# Create Load Balancing Rules
resource "azurerm_lb_rule" "rules" {
  for_each = var.load_balancing_rules # Use the 'load_balancing_rules' variable (map of objects)

  name                           = format("%s-%s-%s-%s", var.environment_name, var.lb_name_suffix, "Rule", each.key)
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "LoadBalancerFrontend" # Assumes a single frontend defined above
  loadbalancer_id                = azurerm_lb.main.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.main.id] # Assumes one backend pool

  # Dynamically link to probe using 'azurerm_lb_probe.probes' (note the name change from 'http_probe' to 'probes')
  probe_id                       = contains(keys(azurerm_lb_probe.probes), each.value.probe_name) ? azurerm_lb_probe.probes[each.value.probe_name].id : null

  disable_outbound_snat         = lookup(each.value, "disable_outbound_snat", false)
  idle_timeout_in_minutes       = lookup(each.value, "idle_timeout_in_minutes", 4)
  load_distribution             = lookup(each.value, "load_distribution", "Default")
  enable_floating_ip            = lookup(each.value, "enable_floating_ip", false)
  enable_tcp_reset              = lookup(each.value, "enable_tcp_reset", false)
 }


# Create NAT Rule
resource "azurerm_lb_nat_rule" "nat_rule" {

  name                           = format("%s-%s-%s", var.environment_name, var.lb_name_suffix, "NAT-Rule")
  resource_group_name            = var.resource_group_name
  protocol                       = "Tcp" # NAT rules are typically Tcp or Udp for RDP/SSH
  frontend_port                  = var.nat_frontend_port
  backend_port                   = var.nat_backend_port
  frontend_ip_configuration_name = "LoadBalancerFrontend" # Assumes a single frontend
  loadbalancer_id                = azurerm_lb.main.id
  
}

# Associate NICs with the Backend Address Pool
resource "azurerm_network_interface_nat_rule_association" "nat_association" {
  network_interface_id  = var.vm_nic_ids[0]
  ip_configuration_name = var.nic_ip_config_name
  nat_rule_id           = azurerm_lb_nat_rule.nat_rule.id
}