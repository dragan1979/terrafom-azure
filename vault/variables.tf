variable "azure_tenant_id" {
  default = ""
  description = "Azure Tenant ID"
}
variable "azure_object_id" {
  default = ""
  description = "Azure Object ID"
} 

 variable azure_application_id {
  default = ""
  description = "Azure application ID"
 }
variable "resource_group_name" {
default = ""
}

variable "resource_group_location" {
default = ""
} 

variable "key_vault_name" {
default = ""

}

variable "environment_name" {
 default = ""

}

variable "network_acl" {
default = "23.2.4.5/32"
description = "Network prefix"
}

variable "key_vault_key_name" {
default = ""
description = "Secret key name"
}


