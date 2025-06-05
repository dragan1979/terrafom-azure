resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  is_hns_enabled = var.is_hns_enabled
  
  min_tls_version   = var.min_tls_version
  
  # Enable Azure AD authentication for storage data plane
  shared_access_key_enabled       = true
  allow_nested_items_to_be_public = false
  
  # Ensure default authentication is set
  default_to_oauth_authentication = true

  blob_properties {
    # Optional blob configuration
    change_feed_enabled = var.blob_change_feed_enabled
    versioning_enabled  = var.blob_versioning_enabled
    
    container_delete_retention_policy {
      days = var.blob_container_delete_retention_days
    }
    
    delete_retention_policy {
      days = var.blob_delete_retention_days
    }
  }
  
  queue_properties {
    dynamic "cors_rule" {
      for_each = var.queue_cors_rules
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }

  share_properties {
    dynamic "cors_rule" {
      for_each = var.share_cors_rules
      content {
        allowed_headers    = cors_rule.value.allowed_headers
        allowed_methods    = cors_rule.value.allowed_methods
        allowed_origins    = cors_rule.value.allowed_origins
        exposed_headers    = cors_rule.value.exposed_headers
        max_age_in_seconds = cors_rule.value.max_age_in_seconds
      }
    }
  }
  
  dynamic "network_rules" {
    # Only create this block if network_rules are enabled
    for_each = var.network_rules_enabled ? ["enabled"] : []
    content {
      default_action             = var.network_rules_default_action
      ip_rules                   = var.network_rules_ip_rules
      virtual_network_subnet_ids = compact([var.network_rules_subnet_ids])
      bypass                     = concat(var.network_rules_bypass, ["AzureServices"])
    }
  }
  
  tags = merge({
    Name = format("%s-%s-%s", var.environment_name, var.storage_account_name, "Storage-Account")
  },
    var.tags_module,
    var.tags_global
  )
}


# Resource: Azure Storage Container (Blob Container)
resource "azurerm_storage_container" "blob_container" {
  for_each              = { for c in var.blob_containers : c.name => c }
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type # "private", "blob", or "container"
}
# Resource: Azure Storage File Share
resource "azurerm_storage_share" "file_share" {
  for_each             = { for s in var.file_shares : s.name => s }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota # in GB

}

# Resource: Azure Storage Queue
resource "azurerm_storage_queue" "queue" {
  for_each             = { for q in var.queues : q.name => q }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name
}

# Resource: Azure Storage Table
resource "azurerm_storage_table" "table" {
  for_each             = { for t in var.tables : t.name => t }
  name                 = each.value.name
  storage_account_name = azurerm_storage_account.this.name

}


resource "azurerm_private_endpoint" "blob_endpoint" {
  count               = var.enable_private_endpoint && contains(var.private_endpoint_subresource_names, "blob") ? 1 : 0
  name                = format("%s-%s", var.storage_account_name, "blob-private-endpoint")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-%s", var.storage_account_name, "blob-private-connection")
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }

}

resource "azurerm_private_endpoint" "file_endpoint" {
  count               = var.enable_private_endpoint && contains(var.private_endpoint_subresource_names, "file") ? 1 : 0
  name                = format("%s-%s", var.storage_account_name, "file-private-endpoint")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-%s", var.storage_account_name, "file-private-connection")
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["file"]
  }
 
}

resource "azurerm_private_endpoint" "queue_endpoint" {
  count               = var.enable_private_endpoint && contains(var.private_endpoint_subresource_names, "queue") ? 1 : 0
  name                = format("%s-%s", var.storage_account_name, "queue-private-endpoint")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-%s", var.storage_account_name, "queue-private-connection")
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["queue"]
  }

}

resource "azurerm_private_endpoint" "table_endpoint" {
  count               = var.enable_private_endpoint && contains(var.private_endpoint_subresource_names, "table") ? 1 : 0
  name                = format("%s-%s", var.storage_account_name, "table-private-endpoint")
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = format("%s-%s", var.storage_account_name, "table-private-connection")
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["table"]
  }
}