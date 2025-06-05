# 1. Configure the Vault Provider
terraform {
  required_version = ">= 1.12.1" # Specifies the minimum required Terraform versio
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = { 
      source  = "hashicorp/azuread"
      version = "~> 2.0" # Use an appropriate version
    }
  }
}

provider "vault" {
  address = "https://vault.example.com" # Your Vault server address

  # The 'VAULT_TOKEN' environment variable will be used automatically.
}

# 2. Retrieve Azure Service Principal Credentials from Vault
data "vault_kv_secret_v2" "azure_sp_creds" {
  mount = "azure-creds"
  name  = "terraform/azure_sp"
}

# 3. Configure the AzureRM Provider using secrets from Vault
provider "azurerm" {
  features {}
  #use_cli = true # Tells Terraform to use Azure CLI's cached token

  client_id       = data.vault_kv_secret_v2.azure_sp_creds.data.client_id
  client_secret   = data.vault_kv_secret_v2.azure_sp_creds.data.client_secret
  tenant_id       = data.vault_kv_secret_v2.azure_sp_creds.data.tenant_id
  subscription_id = data.vault_kv_secret_v2.azure_sp_creds.data.subscription_id
}
#  Get the current Azure Service Principal ObjectID using the client_id from Vault
data "azuread_service_principal" "current" {
  # Use the client_id (Application ID) from Vault to look up the Service Principal
  client_id = data.vault_kv_secret_v2.azure_sp_creds.data.client_id
}
 
data "vault_kv_secret_v2" "windows_vm_credentials" {
  mount = "secret"
  name  = "windows-vm" # The secret name is 'windows-vm'
}

data "vault_kv_secret_v2" "linux_vm_credentials" {
  mount = "secret"
  name  = "linux-vm"   # The secret name is 'linux-vm'
}
