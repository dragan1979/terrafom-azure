#Avilability set

variable "availability_set_update_domain_count" {
  default = "1"
  

  //Virtual machines in the same update domain will be restarted together during planned maintenance.
  //Azure never restarts more than one update domain at a time.
}

variable "availability_set_fault_domain_count" {
  //Virtual machines in the same fault domain share a common power source and physical network switch.

  default = "1"
   
}

variable "availability_set_managed" {
  default = true
  description = "Should Availability set be managed or not"
}

variable "environment_name" {

 default = "test"
 description = "Environmnet name"

}

variable "resource_group_name" {

  default = "myrg1"
  description = "Resource Group Name"
}

variable "resource_group_location" {

  default = "West europe"
  description = "Resource group location"
}

