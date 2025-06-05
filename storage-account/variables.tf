variable "tags_global" {
  default = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}

variable "environment_name" {
  default = "example"
  description = "Prefix (will be atached to every resource)"
}

variable "storage_account_name" {
  description = "The name of the Storage Account. Must be globally unique, lowercase, and between 3 and 24 characters long, consisting only of lowercase letters and numbers."
  type        = string

  validation {
    # Check if the length is between 3 and 24 characters
    condition     = length(var.storage_account_name) >= 3 && length(var.storage_account_name) <= 24
    error_message = "Storage account name must be between 3 and 24 characters long."
  }

  validation {
    # Check if the name consists only of lowercase letters and numbers
    # The regex ^[a-z0-9]+$ means:
    # ^    - start of the string
    # [a-z0-9] - any lowercase letter or number
    # +    - one or more times
    # $    - end of the string
    condition     = can(regex("^[a-z0-9]+$", var.storage_account_name))
    error_message = "Storage account name must consist only of lowercase letters and numbers."
  }
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Storage Account."
  type        = string
}

variable "location" {
  description = "The Azure region where the Storage Account should be created."
  type        = string
}

variable "account_tier" {
  description = "The Tier of the Storage Account. Possible values are 'Standard' or 'Premium'."
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "Invalid account_tier. Must be 'Standard' or 'Premium'."
  }
}

variable "account_replication_type" {
  description = "The Replication Type of the Storage Account. Possible values are 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  type        = string
  default     = "GRS"
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.account_replication_type)
    error_message = "Invalid account_replication_type. Must be one of 'LRS', 'GRS', 'RAGRS', 'ZRS', 'GZRS', 'RAGZRS'."
  }
}

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled for the Storage Account? (Enables Data Lake Storage Gen2)."
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "The minimum TLS version to be permitted on the Storage Account. Possible values are 'TLS1_0', 'TLS1_1', 'TLS1_2'."
  type        = string
  default     = "TLS1_2"
  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.min_tls_version)
    error_message = "Invalid min_tls_version. Must be 'TLS1_0', 'TLS1_1', or 'TLS1_2'."
  }
}

variable "blob_change_feed_enabled" {
  description = "Enable blob change feed"
  type        = bool
  default     = false
}

variable "blob_versioning_enabled" {
  description = "Enable blob versioning"
  type        = bool
  default     = false
}

variable "blob_container_delete_retention_days" {
  description = "Days to retain deleted blob containers"
  type        = number
  default     = 7
}

variable "blob_delete_retention_days" {
  description = "Days to retain deleted blobs"
  type        = number
  default     = 7
}
# Optional: Network ACL (Firewall) settings

variable "network_acl_default_action" {
  description = "The default action for the network ACL. Possible values are 'Allow' or 'Deny'."
  type        = string
  default     = "Deny"
}

variable "network_acl_ip_rules" {
  description = "A list of IP addresses or IP ranges in CIDR format to allow access to the storage account."
  type        = list(string)
  default     = []
}

variable "network_acl_subnet_ids" {
  description = "A list of Virtual Network Subnet IDs to allow access to the storage account."
  type        = list(string)
  default     = []
}

variable "network_acl_bypass" {
  description = "A list of services to bypass the network ACL. Possible values are 'AzureServices', 'Logging', 'Metrics', 'None'."
  type        = list(string)
  default     = ["AzureServices"]
}

variable "network_rules_enabled" {
  description = "Set to true to enable network rules (firewall) for the storage account."
  type        = bool
  default     = false
}

variable "network_rules_default_action" {
  description = "The default action for the network rules. Possible values are 'Allow' or 'Deny'."
  type        = string
  default     = "Deny"
  validation {
    condition     = contains(["Allow", "Deny"], var.network_rules_default_action)
    error_message = "Invalid network_rules_default_action. Must be 'Allow' or 'Deny'."
  }
}

variable "network_rules_ip_rules" {
  description = "A list of IP addresses or IP ranges in CIDR format to allow access to the storage account."
  type        = list(string)
  default     = []
}


variable "network_rules_subnet_ids" {
  description = "A single Virtual Network Subnet ID to allow access to the storage account. Leave empty to not allow access via subnet."
  type        = string # CHANGED: from list(string) to string
  default     = ""     # Default to an empty string
}

variable "network_rules_bypass" {
  description = "A list of services to bypass the network rules. Possible values are 'AzureServices', 'Logging', 'Metrics', 'None'."
  type        = list(string)
  default     = ["AzureServices"]
  validation {
    condition     = alltrue([for s in var.network_rules_bypass : contains(["AzureServices", "Logging", "Metrics", "None"], s)])
    error_message = "Invalid value in network_rules_bypass. Must be one of 'AzureServices', 'Logging', 'Metrics', 'None'."
  }
}

# Optional: Blob Containers
variable "blob_containers" {
  description = "A list of blob containers to create within the storage account."
  type = list(object({
    name        = string
    access_type = string # "private", "blob", or "container"
  }))
  default = []
}

# Optional: File Shares
variable "file_shares" {
  description = "A list of file shares to create within the storage account."
  type = list(object({
    name  = string
    quota = number # in GB
  }))
  default = []
}

# Optional: Queues
variable "queues" {
  description = "A list of queues to create within the storage account."
  type = list(object({
    name = string
  }))
  default = []
}

# Optional: Tables
variable "tables" {
  description = "A list of tables to create within the storage account."
  type = list(object({
    name = string
  }))
  default = []
}

# Optional: Queue Properties (CORS)
variable "queue_properties_enabled" {
  description = "Set to true to enable queue service properties (e.g., CORS)."
  type        = bool
  default     = false
}

variable "queue_cors_rules" {
  description = "A list of CORS rules for the Queue Service."
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string) # e.g., ["GET", "PUT", "POST"]
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

# Optional: Table Properties (CORS)
variable "table_properties_enabled" {
  description = "Set to true to enable table service properties (e.g., CORS)."
  type        = bool
  default     = false
}

variable "table_cors_rules" {
  description = "A list of CORS rules for the Table Service."
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string) # e.g., ["GET", "PUT", "POST"]
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "share_cors_rules" {
  description = "A list of CORS rules for the File Service."
  type = list(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string) # e.g., ["GET", "PUT", "POST"]
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = []
}

variable "enable_private_endpoint" {
  description = "Set to true to create a Private Endpoint for the Storage Account."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the subnet where the Private Endpoint will be deployed. Required if enable_private_endpoint is true."
  type        = string
  default     = null # Use null as default for required variables in conditional blocks
}

variable "private_endpoint_subresource_names" {
  description = "A list of sub-resources (e.g., 'blob', 'queue', 'table', 'file', 'web', 'dfs') to create private endpoints for."
  type        = list(string)
  default     = ["blob"] # Default to just blob, commonly used
  validation {
    condition = alltrue([
      for sub in var.private_endpoint_subresource_names : contains(["blob", "queue", "table", "file", "web", "dfs"], sub)
    ])
    error_message = "Invalid subresource_names. Must be 'blob', 'queue', 'table', 'file', 'web', or 'dfs'."
  }
}

variable "access_tier" {
  description = "The access tier used for blobs in the storage account. Possible values are 'Hot', 'Cool' and 'Archive'."
  type        = string
  default     = "Hot" # Common default, you can adjust this
  validation {
    condition     = contains(["Hot", "Cool", "Archive"], var.access_tier)
    error_message = "The access_tier must be 'Hot', 'Cool', or 'Archive'."
  }
}
