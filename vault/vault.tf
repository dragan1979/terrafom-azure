#AZURE KEY VAULT
resource "azurerm_key_vault" "this" {
    name                            = format("%s-%s", var.environment_name, var.key_vault_name)
    location                        = var.resource_group_location
    resource_group_name             = var.resource_group_name
    #Azure Active Directory tenant ID
    tenant_id                       = var.azure_tenant_id
    #specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault
    enabled_for_deployment          = true
    #specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys
    enabled_for_disk_encryption     = true
    #specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault
    enabled_for_template_deployment = true
    # Enable purge protection (required for disk encryprtion set)
    soft_delete_retention_days      = 7
    purge_protection_enabled        = true
    # Enable RBAC authorization for the Key Vault
      enable_rbac_authorization     = true
#Sku standard/premium
    
    sku_name                        = "standard"
  
#Network Access Lists, Security is bypassed for the Azure Services and Azure
#Key Vault is reachable from a remote network based on a IP. Azure Key Vault
#is not reachable from the Internet (Deny)
    network_acls {
        #which traffic can bypass the network rules
        bypass                      = "AzureServices"
        #Default action is Deny
        default_action              = "Deny"
        ip_rules                    = var.network_acl
                
    }
 
  tags                            = merge({Name=format("%s-%s-%s", var.environment_name, var.key_vault_name, "Key-Vault")})
     
}

# --- Introduce a delay to allow RBAC to propagate ---
resource "time_sleep" "wait_for_rbac_key_creation_permissions" {
  create_duration = "30s" # Adjust as needed, e.g., "60s", "2m", "5m".

  depends_on = [
    azurerm_role_assignment.user_key_rbac_access
  ]
}

# --- Key Vault Key for Disk Encryption ---
resource "azurerm_key_vault_key" "disk_encryption_key" {
  name         = format("%s-%s-%s", var.environment_name, var.key_vault_key_name, "Vault-key")
  key_vault_id = azurerm_key_vault.this.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey",
  ]
  depends_on = [
    time_sleep.wait_for_rbac_key_creation_permissions
  ]
}


# --- Disk Encryption Set (DES) ---
resource "azurerm_disk_encryption_set" "des" {
  name                      = format("%s-%s", var.environment_name, "VM-Disk-encryption-set")
  resource_group_name       = var.resource_group_name
  location                  = var.resource_group_location
  key_vault_key_id          = azurerm_key_vault_key.disk_encryption_key.id # Link to the key in Key Vault
  #auto_key_rotation_enabled = true
  identity {
    type = "SystemAssigned" # System-assigned managed identity for the DES
  }
  depends_on = [ time_sleep.wait_for_rbac_key_creation_permissions]
}

resource "azurerm_role_assignment" "user_key_rbac_access" {
  principal_id         = var.azure_object_id # The Azure AD Object ID of the user/service principal
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"

  # Explicit dependency to ensure Key Vault is created before assignment
  depends_on = [azurerm_key_vault.this]
}

# 
resource "azurerm_role_assignment" "des_rbac_access" {
  principal_id         = azurerm_disk_encryption_set.des.identity[0].principal_id
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Crypto Service Encryption User" # Standard role for DES

  # Explicit dependency to ensure DES identity is created before assignment
  depends_on = [
    azurerm_disk_encryption_set.des, azurerm_key_vault.this
  ]
} 


# Creating secret

#resource "azurerm_key_vault_secret" "this" {
#  name                              = format("%s-%s-%s", var.environment_name, "secret-sauce", "Vault-secret")
#  value                             = "szechuan"
#  key_vault_id                      = azurerm_key_vault.this.id
#  depends_on                        = [azurerm_key_vault.this] 
#  tags                              = merge(map("Name", format("%s-%s-%s", var.environment_name, "secret-sauce", "Vault-secret")))
#}

