resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.project_name}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false
  soft_delete_retention_days  = 7
  enabled_for_disk_encryption = true
  tags                        = var.tags

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Purge", "Recover", "Restore", "Delete"]
  }

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }

  lifecycle {
    ignore_changes = [
      tags["CreatedDate"],
      network_acls[0].ip_rules
    ]
  }
}

resource "azurerm_key_vault_secret" "openai_key" {
  name         = "OpenAIKey"
  value        = azurerm_cognitive_account.openai.primary_access_key
  key_vault_id = azurerm_key_vault.keyvault.id
}

resource "azurerm_key_vault_access_policy" "app_access_policy" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_linux_web_app.app.identity[0].principal_id

  secret_permissions = ["Get"]
}
