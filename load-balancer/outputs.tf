output "load_balancer_id" {
  description = "The ID of the Azure Load Balancer."
  value       = azurerm_lb.main.id
}

output "load_balancer_public_ip_id" {
  description = "The ID of the Public IP address associated with the Load Balancer frontend."
  value       = azurerm_public_ip.lb_public_ip.id
}

output "load_balancer_public_ip_address" {
  description = "The public IP address of the Azure Load Balancer."
  value       = azurerm_public_ip.lb_public_ip.ip_address
}

output "backend_address_pool_id" {
  description = "The ID of the Load Balancer Backend Address Pool."
  value       = azurerm_lb_backend_address_pool.main.id
}

output "load_balancing_rule_ids" {
  description = "A map of IDs for the created Load Balancing Rules, keyed by their rule names."
  # Corrected: Use a for expression to iterate over the map and get IDs
  value       = { for k, v in azurerm_lb_rule.rules : k => v.id }
}

output "probe_ids" {
  description = "A map of IDs for the created Health Probes, keyed by their probe names."
  # Use a for expression to iterate over the map of probes and extract each ID
  value       = { for k, v in azurerm_lb_probe.probes : k => v.id }
}

output "nat_rule_id" { # Changed name to singular 'nat_rule_id'
  description = "The ID of the created NAT Rule."
  value       = azurerm_lb_nat_rule.nat_rule.id # Changed reference to singular 'nat_rule'
}

output "nat_frontend_port_used" { # Changed name to singular 'nat_frontend_port_used'
  description = "The public frontend port used for the NAT rule."
  value       = var.nat_frontend_port # Output the single port that was passed in
}