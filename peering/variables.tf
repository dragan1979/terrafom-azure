variable "vnet1_id" {
  description = "The resource ID of the first Virtual Network to peer."
  type        = string
}

variable "vnet1_name" {
  description = "The name of the first Virtual Network to peer."
  type        = string
}

variable "vnet1_rg_name" {
  description = "The resource group name of the first Virtual Network."
  type        = string
}

variable "vnet2_id" {
  description = "The resource ID of the second Virtual Network to peer."
  type        = string
}

variable "vnet2_name" {
  description = "The name of the second Virtual Network to peer."
  type        = string
}

variable "vnet2_rg_name" {
  description = "The resource group name of the second Virtual Network."
  type        = string
}