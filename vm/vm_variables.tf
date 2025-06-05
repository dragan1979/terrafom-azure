# Multi-VM Variables - variables.tf
# Replace the content of your existing vm/variables.tf file with this content

variable "tags_global" {
  default     = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}

variable "instances" {
  type        = number
  default     = 1
  description = "Number of VM instances to create"
}

variable "vm_size" {
  default     = ""
  description = "VM instance size"
}

variable "vm_image_publisher" {
  default     = ""
  description = "vm image vendor"
}

variable "vm_image_offer" {
  default     = ""
  description = "vm image vendor's VM offering"
}

variable "vm_image_sku" {
  default     = ""
  description = "An instance of an offer, such as a major release of a distribution. Examples: 18.04-LTS, 2019-Datacenter"
}

variable "vm_image_version" {
  default     = "latest"
  description = "The version number of an image SKU."
}

variable "vm_admin" {
  default     = ""
  description = "VM administrator"
}

variable "vm_password" {
  default     = ""
  description = "VM password"
}

variable "vm_name" {
  type        = list(string)
  default     = ["myvm"]
  description = "List of VM names as seen in Azure portal"
}

variable "computer_name" {
  type        = list(string)
  default     = []
  description = "List of Local/OS VM names. If not provided, vm_name will be used"
}

variable "resource_group_name" {
  default     = ""
  description = "Resource group name"
}

variable "resource_group_location" {
  default     = ""
  description = "Resource group location"
}

variable "encryption" {
  default     = false
  description = "Should OS disk will be encrypted"
}

variable "public_ip" {
  type        = list(bool)
  default     = [false]
  description = "List of boolean values indicating whether public IP should be assigned to each VM"
}

variable "os" {
  default     = ""
  description = "is VM linux or windows"
}

variable "ssh_public_key" {
  default     = ""
  description = "Public key used to connect to Linux VM"
}

variable "environment_name" {
  default     = "example"
  description = "Prefix (will be attached to every resource)"
}

variable "number_of_managed_disks" {
  type        = list(number)
  default     = []
  description = "List of number of managed disks for each VM"
}

variable "disk_sizes" {
  type        = list(list(number))
  default     = []
  description = "List of disk sizes for each VM. Each element is a list of disk sizes for that VM"
}

variable "key_vault_url" {
  default     = ""
  description = "Key vault URL"
}

variable "key_vault_id" {
  default     = ""
  description = "Key Vault resource ID"
}

variable "key_encryption_key_name" {
  default     = ""
  description = "Key Value encryption key name"
}

variable "key_encryption_key_version" {
  default     = ""
  description = "Key encryption key version"
}

variable "key_vault_secret_id" {
  default     = ""
  description = "Key Vault secret key ID"
}

variable "key_encryption_key_id" {
  default     = ""
  description = "Key Encryption key ID"
}

variable "subnet_id" {
  default     = ""
  description = "VNET subnet id"
}

variable "key_vault_name" {
  default = ""
}

variable "network_acl" {
  default     = ""
  description = "Network prefix"
}

locals {
  isWin    = var.os == "windows" ? [1] : []
  isNotWin = var.os == "windows" ? [] : [1]
}

variable "disk_encryption_set_id" {
  default     = ""
  description = "Disk encryption set ID"
}

variable "enable_disk_encryption" {
  type        = list(bool)
  default     = [false]
  description = "List of boolean values indicating whether to enable disk encryption for each VM"
}

variable "availability_set_id" {
  default     = ""
  description = "Availability set ID"
}