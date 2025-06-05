variable "enable_wan_subnet" {
  default     = false
  description = "Controls if the WAN subnets will be deployed or not."
}

variable "enable_wan_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the WAN subnet."
  type        = bool
  default     = false
}

variable "enable_dmz_subnet" {
  default     = false
  description = "Controls if the DMZ subnets will be deployed or not."
}

variable "enable_dmz_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the DMZ subnet."
  type        = bool
  default     = false
}

variable "enable_vdi_subnet" {
  default     = false
  description = "Controls if the VDI subnets will be deployed or not."
}

variable "enable_vdi_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the VDI subnet."
  type        = bool
  default     = false
}

variable "enable_infrastructure_services_subnet" {
  default     = false
  description = "Controls if the Infrastructure Services subnets will be deployed or not."
}

variable "enable_infrastructure_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Infrastructure Services subnet."
  type        = bool
  default     = false
}

variable "enable_infrastructure_db_services_subnet" {
  default     = false
  description = "Controls if the Infrastructure DB Services subnets will be deployed or not."
}

variable "enable_infrastructure_db_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Infrastructure DB Services subnet."
  type        = bool
  default     = false
}

variable "enable_production_app_services_subnet" {
  default     = false
  description = "Controls if the Production App Services subnets will be deployed or not."
}

variable "enable_production_app_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Production App Services subnet."
  type        = bool
  default     = false
}

variable "enable_production_db_services_subnet" {
  default     = false
  description = "Controls if the Production DB Services subnets will be deployed or not."
}

variable "enable_production_db_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Production DB Services subnet."
  type        = bool
  default     = false
}

variable "enable_acceptance_app_services_subnet" {
  default     = false
  description = "Controls if the Acceptance App Services subnets will be deployed or not."
}

variable "enable_acceptance_app_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Acceptance App Services subnet."
  type        = bool
  default     = false
}

variable "enable_acceptance_db_services_subnet" {
  default     = false
  description = "Controls if the Acceptance DB Services subnets will be deployed or not."
}

variable "enable_acceptance_db_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Acceptance DB Services subnet."
  type        = bool
  default     = false
}

variable "enable_test_app_services_subnet" {
  default     = false
  description = "Controls if the Test App Services subnets will be deployed or not."
}

variable "enable_test_app_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Test App Services subnet."
  type        = bool
  default     = false
}

variable "enable_test_db_services_subnet" {
  default     = false
  description = "Controls if the Test DB Services subnets will be deployed or not."
}

variable "enable_test_db_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Test DB Services subnet."
  type        = bool
  default     = false
}

variable "enable_development_app_services_subnet" {
  default     = false
  description = "Controls if the Development App Services subnets will be deployed or not."
}

variable "enable_development_app_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Development App Services subnet."
  type        = bool
  default     = false
}

variable "enable_development_db_services_subnet" {
  default     = false
  description = "Controls if the Development DB Services subnets will be deployed or not."
}

variable "enable_development_db_services_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Development DB Services subnet."
  type        = bool
  default     = false
}

variable "enable_gateway_subnet" {
  default     = false
  description = "Controls if the Gateway subnets will be deployed or not."
}

variable "enable_gateway_storage_endpoint" {
  description = "Controls if the Microsoft.Storage service endpoint is enabled for the Gateway subnet."
  type        = bool
  default     = false
}