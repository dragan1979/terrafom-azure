variable "vnet_name" {
  default = ""
  description = "VNET name"
  
}

variable "tags_global" {
  default = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}

variable "environment_name" {
  default = ""
  description = "Environment (customer) name"
}

variable "environment_type" {
  default     = "production"
  description = "'production' or 'acceptance' or 'testing' or 'development'"
}

variable "resource_group_name" {
  default = ""
  description = "Resource group name"
}

variable "resource_group_location" {
  default = ""
  description = "Resource group location"
}

variable "dns_servers" {
  default = []
  description = "DNS servers"
}

variable "cidr_block" {
  default     = ""
  description = "The address prefix to use for the subnet."
}