output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = azurerm_storage_account.this.primary_access_key
  sensitive   = true # Mark as sensitive to prevent logging
}

output "primary_connection_string" {
  description = "The primary connection string for the Storage Account."
  value       = azurerm_storage_account.this.primary_connection_string
  sensitive   = true # Mark as sensitive to prevent logging
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint for the Storage Account."
  value       = azurerm_storage_account.this.primary_blob_endpoint
}

output "primary_file_endpoint" {
  description = "The primary file endpoint for the Storage Account."
  value       = azurerm_storage_account.this.primary_file_endpoint
}

output "primary_queue_endpoint" {
  description = "The primary queue endpoint for the Storage Account."
  value       = azurerm_storage_account.this.primary_queue_endpoint
}

output "primary_table_endpoint" {
  description = "The primary table endpoint for the Storage Account."
  value       = azurerm_storage_account.this.primary_table_endpoint
}

output "blob_container_ids" {
  description = "A map of created blob container names to their IDs."
  value       = { for k, v in azurerm_storage_container.blob_container : k => v.id }
}

output "file_share_ids" {
  description = "A map of created file share names to their IDs."
  value       = { for k, v in azurerm_storage_share.file_share : k => v.id }
}