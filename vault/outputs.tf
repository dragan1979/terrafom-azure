output "key_vault_url" {
  value       = azurerm_key_vault.this.vault_uri
  description = "Key Vault URL."
  depends_on = [
    azurerm_key_vault.this,
  ]
 }

output "key_vault_id" {
  value       = azurerm_key_vault.this.id
  description = "Key vault ID."

  depends_on = [
    azurerm_key_vault.this,
  ]
}

output "key_vault_name" {
  value       = azurerm_key_vault.this.name
  description = "Key vault name"

  depends_on = [
    azurerm_key_vault.this,
  ]
}

#output "key_vault_secret_id" {
#  value       = azurerm_key_vault_secret.this.id
#  description = "Key vault secret ID."
#   depends_on = [
#    azurerm_key_vault_secret.this,
#  ]
#}


output "key_encryption_key_name" {
  value       = azurerm_key_vault_key.disk_encryption_key.name
  description = "Key vault key name."
 
  depends_on = [
    azurerm_key_vault_key.disk_encryption_key,
  ]
}



output "key_encryption_key_id" {
  value       = azurerm_key_vault_key.disk_encryption_key.id
  description = "Key vault key ID."
 
  depends_on = [
    azurerm_key_vault_key.disk_encryption_key,
 
  ]
}

output "key_encryption_key_version" {
  value       = azurerm_key_vault_key.disk_encryption_key.version
  description = "Key vault key version."
    depends_on = [
    azurerm_key_vault_key.disk_encryption_key,
  ]
}

output "disk_encryption_set_id" {
  value       = azurerm_disk_encryption_set.des.id
  description = "Disk encryption set ID"
    depends_on = [
    azurerm_disk_encryption_set.des,
  ]
}