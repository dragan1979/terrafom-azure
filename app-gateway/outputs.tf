# --- Data Source to fetch external Public IP details (if not created internally) ---
# This data source will be created ONLY IF:
# 1. The module was *not* asked to create a public IP internally (var.create_public_ip is false)
# 2. AND the provisioned Application Gateway actually has a public_ip_address_id on its first frontend_ip_configuration.
data "azurerm_public_ip" "external_ag_pip" {
  # The entire conditional expression for 'count' must be within parentheses
  count = (
    !var.create_public_ip &&
    length(azurerm_application_gateway.this.frontend_ip_configuration) > 0 &&
    azurerm_application_gateway.this.frontend_ip_configuration[0].public_ip_address_id != null
  ) ? 1 : 0

  # Get the ID of the public IP that the App Gateway's first frontend is actually using.
  # This relies on the App Gateway resource being deployed first.
  # Note: [0] assumes a single public frontend is the primary one.
  # If you expect multiple public frontends, you'd need more complex logic (e.g., a 'for_each' on data blocks).
  name                = split("/", azurerm_application_gateway.this.frontend_ip_configuration[0].public_ip_address_id)[8]
  resource_group_name = split("/", azurerm_application_gateway.this.frontend_ip_configuration[0].public_ip_address_id)[4]
}

output "application_gateway_id" {
  description = "The ID of the Application Gateway"
  value       = azurerm_application_gateway.this.id
}

output "application_gateway_name" {
  description = "The name of the Application Gateway"
  value       = azurerm_application_gateway.this.name
}

output "application_gateway_frontend_ip_configuration" {
  description = "The frontend IP configuration of the Application Gateway"
  value       = azurerm_application_gateway.this.frontend_ip_configuration
}

output "application_gateway_backend_address_pool" {
  description = "The backend address pools of the Application Gateway"
  value       = azurerm_application_gateway.this.backend_address_pool
}