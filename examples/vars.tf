variable "resource_group_name" {
  default = "myrg1"
  description = "Resource Group Name"
}
variable "resource_group_location" {

  default = "West europe"
  description = "Resource group location"
}
variable "environment_name" {

 default = "test"
 description = "Environmnet name"
}
variable "tags_global" {
  default = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}
