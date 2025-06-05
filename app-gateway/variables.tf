variable "tags_global" {
  default = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}

variable "environment_name" {
  description = "The name of the environment (e.g., 'dev', 'test', 'prod')."
  type        = string
  default     = "dev"
}


variable "app-gateway-name" {
  description = "The name of the Application Gateway."
  type        = string
}

variable "location" {
  description = "The Azure region where the Application Gateway should be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Application Gateway."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the Subnet where the Application Gateway will be deployed."
  type        = string
}

variable "sku_tier" {
  description = "The SKU tier of the Application Gateway. Possible values are 'Standard', 'Standard_v2', 'WAF', 'WAF_v2'."
  type        = string
  default     = "Standard_v2"
  validation {
    condition     = contains(["Standard", "Standard_v2", "WAF", "WAF_v2"], var.sku_tier)
    error_message = "Invalid sku_tier. Must be one of 'Standard', 'Standard_v2', 'WAF', 'WAF_v2'."
  }
}

variable "sku_capacity" {
  description = "The number of instances of the Application Gateway. For WAF_v2, this can be between 1 and 125."
  type        = number
  default     = 1
}

variable "frontend_ip_configurations" {
  description = "A list of frontend IP configurations for the Application Gateway."
  type = list(object({
    name                     = string
    public_ip_address_id     = optional(string) # Make this optional
    private_ip_address       = optional(string)
    private_ip_address_allocation = optional(string, "Dynamic") # Static or Dynamic
  }))
}

variable "frontend_port_configurations" {
  description = "A list of frontend port configurations for the Application Gateway."
  type = list(object({
    name = string
    port = number
  }))
}

variable "backend_address_pools" {
  description = "A list of backend address pools for the Application Gateway."
  type = list(object({
    name    = string
    fqdns   = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "A list of backend HTTP settings for the Application Gateway."
  type = list(object({
    name                                = string
    cookie_based_affinity               = string # "Enabled" or "Disabled"
    path_based_routing_default_backend_address_pool_name = optional(string)
    port                                = number
    protocol                            = string # "Http", "Https"
    request_timeout                     = number
    probe_name                          = optional(string)
    host_name                           = optional(string)
    pick_host_name_from_backend_address = optional(bool)
  }))
}

variable "http_listeners" {
  description = "A list of HTTP listeners for the Application Gateway."
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string # "Http", "Https"
    host_name                      = optional(string)
    require_sni                    = optional(bool)
    ssl_certificate_name           = optional(string)
  }))
}

variable "request_routing_rules" {
  description = "A list of request routing rules for the Application Gateway."
  type = list(object({
    name                        = string
    rule_type                   = string # "Basic", "PathBasedRouting"
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    url_path_map_name           = optional(string)
    redirect_configuration_name = optional(string)
    rewrite_rule_set_name       = optional(string)
  }))
}

variable "probes" {
  description = "A list of health probes for the Application Gateway."
  type = list(object({
    name                                = string
    protocol                            = string # "Http", "Https"
    host                                = string
    path                                = string
    interval                            = number
    timeout                             = number
    unhealthy_threshold                 = number
    pick_host_name_from_backend_http_settings = optional(bool)
    match_body                          = optional(string)
    match_status_codes                  = optional(list(string))
  }))
  default = [] # Optional, so default to empty list
}

# WAF Configuration Variables
variable "enable_waf" {
  description = "Set to true to enable Web Application Firewall (WAF) on the Application Gateway."
  type        = bool
  default     = false
}

variable "waf_mode" {
  description = "The Web Application Firewall (WAF) mode. Possible values are 'Detection' or 'Prevention'."
  type        = string
  default     = "Prevention"
  validation {
    condition     = contains(["Detection", "Prevention"], var.waf_mode)
    error_message = "Invalid waf_mode. Must be 'Detection' or 'Prevention'."
  }
}

variable "waf_rule_set_type" {
  description = "The type of the WAF rule set. Possible values are 'OWASP'."
  type        = string
  default     = "OWASP"
}

variable "waf_rule_set_version" {
  description = "The version of the WAF rule set. Possible values are '2.2', '3.0', '3.1', '3.2'."
  type        = string
  default     = "3.2"
  validation {
    condition     = contains(["2.2", "3.0", "3.1", "3.2"], var.waf_rule_set_version)
    error_message = "Invalid waf_rule_set_version. Must be one of '2.2', '3.0', '3.1', '3.2'."
  }
}

variable "waf_disabled_rule_groups" {
  description = "A list of objects for rule groups to disable in the WAF rule set. Each object can include 'rules' for specific rule IDs within that group."
  type = list(object({
    rule_group_name = string
    rules           = optional(list(number)) # Specific rules within this group
  }))
  default = []
}
variable "waf_disabled_rules" {
  description = "A list of rule IDs to disable in the WAF rule set."
  type        = list(number)
  default     = [] # Example: [920300, 920310]
}

variable "waf_exclusion_rules" {
  description = "A list of WAF exclusion rules. See Azure documentation for structure."
  type = list(object({
    match_variable    = string # "RequestHeaderNames", "RequestCookieNames", "RequestArgNames", "RequestBodyPostArgNames", "RequestHeaderKeys", "RequestCookieKeys", "RequestArgKeys"
    selector_match_operator = string # "Equals", "StartsWith", "EndsWith", "Contains", "EqualsAny", "RegEx"
    selector          = string
  }))
  default = []
}

variable "waf_custom_rules" {
  description = "A list of WAF custom rules. See Azure documentation for structure."
  type = list(object({
    name             = string
    priority         = number
    rule_type        = string # "MatchRule", "RateLimitRule"
    action           = string # "Allow", "Block", "Log"
    match_conditions = list(object({
      match_variables = list(object({
        variable_name = string # "RemoteAddr", "RequestMethod", "QueryString", "PostArgs", "RequestHeaders", "RequestUri", "RequestBody", "RequestCookies"
        selector      = optional(string)
      }))
      operator        = string # "IPMatch", "Contains", "Equals", "EndsWith", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual", "NoOp", "NotNull", "Prefix", "RegEx", "StartsWith", "GeoMatch"
      negation_condition = optional(bool)
      values          = optional(list(string))
      transforms      = optional(list(string)) # "Lowercase", "RemoveNulls", "Trim", "UrlDecode", "UrlEncode"
    }))
  }))
  default = []
}


variable "availability_zone" {
  description = "A list of Availability Zones for the Load Balancer's Public IP. Leave empty for a non-zonal (regional) deployment. Example: ['1', '2', '3']"
  type        = list(string)
  default     = [] # Default to a non-zonal (regional) deployment
}


variable "create_public_ip" {
  description = "Set to true to create a public IP within this module for the Application Gateway. If false, existing public_ip_address_id must be provided in frontend_ip_configurations if a public frontend is desired."
  type        = bool
  default     = true # Default to creating it internally for convenience
}

# Add variables specific to the internally created public IP
variable "public_ip_allocation_method" {
  description = "The allocation method for the public IP. Must be 'Static' for App Gateway v2."
  type        = string
  default     = "Static" # App Gateway V2 requires Static SKU
  validation {
    condition     = var.public_ip_allocation_method == "Static"
    error_message = "Application Gateway v2 requires 'Static' allocation method for public IP."
  }
}

variable "public_ip_sku" {
  description = "The SKU for the public IP. Must be 'Standard' for App Gateway v2."
  type        = string
  default     = "Standard" # App Gateway V2 requires Standard SKU Public IP
  validation {
    condition     = var.public_ip_sku == "Standard"
    error_message = "Application Gateway v2 requires 'Standard' SKU for public IP."
  }
}

variable "public_ip_zones" {
  description = "A list of Availability Zones for the public IP. Must match App Gateway zones if specified."
  type        = list(string)
  default     = [] # Default to no zones (regional)
}

variable "ssl_certificates" {
  description = "A list of SSL certificates to upload to the Application Gateway."
  type = list(object({
    name = string
    data = string # Base64 encoded PFX certificate data
    password = string # Password for the PFX certificate
  }))
  default = [] # Make it optional
}