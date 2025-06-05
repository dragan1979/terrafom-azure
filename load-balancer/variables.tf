variable "tags_global" {
  default = {}
  description = "global tag"
}

variable "tags_module" {
  default = {}
}

variable "resource_group_name" {

  default = ""
  description = "Resource group name"
}

variable "resource_group_location" {

  default = ""
  description = "Resource group location"

} 

variable "allocation_method" {
  default = ""
  description = "Allocation method for the public IP address,e.g., 'Standard' or 'Basic"
}

variable "sku" {
  description = "The SKU of the Load Balancer and Public IP. Can be 'Basic' or 'Standard'."
  type        = string
  default     = "Standard" # 'Standard' is recommended for production workloads and supports Zones
  validation {
    condition     = contains(["Basic", "Standard"], var.sku)
    error_message = "The 'sku' must be either 'Basic' or 'Standard'."
  }
}

variable "availability_zone" {
  description = "A list of Availability Zones for the Load Balancer's Public IP. Leave empty for a non-zonal (regional) deployment. Example: ['1', '2', '3']"
  type        = list(string)
  default     = [] # Default to a non-zonal (regional) deployment
}


variable "load_balancer_name" {
  description = "The name of the Azure Load Balancer."
  type        = string
}


variable "lb_protocol" {
  description = "The protocol for the Load Balancer Health Probe and Rule. Can be 'Tcp', 'Http', or 'Https' for probes; 'Tcp', 'Udp', or 'All' for rules."
  type        = string
  default     = "Tcp" # Default for many applications, adjust as needed
  validation {
    condition     = contains(["Tcp", "Http", "Https", "Udp", "All"], var.lb_protocol)
    error_message = "The 'lb_protocol' must be 'Tcp', 'Http', 'Https', 'Udp', or 'All'."
  }
}


variable "vm_nic_ids" {
  description = "A list of Network Interface IDs for the backend VMs to be associated with the Load Balancer backend pool."
  type        = list(string)
  default     = [] # Can be empty if no NICs are associated initially
}

variable "target_nat_vm_id" {
  description = "The Virtual Machine ID for the NAT rule."
  type        = string
}

variable "nat_frontend_port" { # Single frontend port
  description = "The unique public frontend port for the NAT rule (e.g., 8080 for RDP over NAT)."
  type        = number
  default     = 8080 # Provide a common default, or remove if always explicitly provided
}

variable "nat_backend_port" {
  description = "The backend port on the target VM for the NAT rule (e.g., 3389 for RDP, 22 for SSH)."
  type        = number
  default     = 3389 # Common default for RDP
}


variable "load_balancing_rules" {
  description = "A map of Load Balancing Rule configurations. Keys are logical rule names."
  type = map(object({
    protocol                = string  # e.g., "Tcp", "Udp"
    frontend_port           = number  # Public port exposed on the Load Balancer
    backend_port            = number  # Port on the backend VMs
    probe_name              = string  # Name of the health probe to associate with this rule (must exist in 'probes' variable keys)
    disable_outbound_snat   = optional(bool, false)  # Whether to disable outbound SNAT for this rule (Standard SKU only)
    idle_timeout_in_minutes = optional(number, 4)    # The timeout for inactive connections
    load_distribution       = optional(string, "Default") # How traffic is distributed (e.g., "Default", "SourceIP", "SourceIPProtocol")
    enable_floating_ip      = optional(bool, false)  # Whether Floating IP is enabled
    enable_tcp_reset        = optional(bool, false)  # Whether TCP Reset is enabled
  }))
  # Example usage in the calling module (main.tf):
  # load_balancing_rules = {
  #   "HTTPRule" = {
  #     protocol      = "Tcp"
  #     frontend_port = 80
  #     backend_port  = 80
  #     probe_name    = "HTTPProbe" # Must match a key in your 'probes' variable
  #   },
  #   "HTTPSRule" = {
  #     protocol      = "Tcp"
  #     frontend_port = 443
  #     backend_port  = 443
  #     probe_name    = "HTTPSProbe" # Must match a key in your 'probes' variable
  #     idle_timeout_in_minutes = 30
  #   }
  # }
}


variable "probes" {
  description = "A map of Health Probe configurations. Keys are logical probe names."
  type = map(object({
    protocol            = string  # e.g., "Tcp", "Http", "Https"
    port                = number  # Port on the backend VMs to probe
    interval_in_seconds = optional(number, 5) # How often to probe in seconds
    number_of_probes    = optional(number, 2) # Number of unsuccessful probes before marking as unhealthy
    request_path        = optional(string) # Required for HTTP/HTTPS probes, e.g., "/health"
  }))
  # Example usage in the calling module (main.tf):
  # probes = {
  #   "HTTPProbe" = {
  #     protocol     = "Http"
  #     port         = 80
  #     request_path = "/health"
  #   },
  #   "HTTPSProbe" = {
  #     protocol     = "Https"
  #     port         = 443
  #     request_path = "/status"
  #     interval_in_seconds = 10
  #   }
  # }
}

variable "lb_name_suffix" {
  description = "A suffix to append to the names of Load Balancer resources (e.g., LB, Public IP, Backend Pool)."
  type        = string
  # Example: "web-tier"
}

variable "environment_name" {
  default = "example"
  description = "Prefix (will be atached to every resource)"
}

variable "nic_ip_config_name" {
  description = "The name of the IP Configuration on the Network Interface that should be associated with the Load Balancer's Backend Address Pool. Common value is 'ipconfig1'."
  type        = string
  default     = "" # Provide a common default, or make it required if always explicitly provided.
}