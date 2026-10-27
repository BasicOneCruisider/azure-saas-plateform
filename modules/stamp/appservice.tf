# -----------------------------------------------------------------------------
# App Service Plan (Le serveur qui héberge l'application)
# -----------------------------------------------------------------------------
resource "azurerm_service_plan" "this" {
  name                = "asp-${var.stamp_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_sku_name
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Linux Web App (L'application elle-même)
# -----------------------------------------------------------------------------
resource "azurerm_linux_web_app" "this" {
  name                = local.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on              = true
    vnet_route_all_enabled = true
  }

  virtual_network_subnet_id = azurerm_subnet.app_integration.id

  app_settings = {
    "WEBSITES_PORT"     = "8080"
    "SQL_SERVER_FQDN"   = azurerm_mssql_server.this.fully_qualified_domain_name
    "SQL_DATABASE_NAME" = azurerm_mssql_database.this.name
    "KEY_VAULT_URI"     = azurerm_key_vault.this.vault_uri
  }
}

# -----------------------------------------------------------------------------
# RBAC : Donne à l'App Service le droit de LIRE les secrets du Key Vault
# -----------------------------------------------------------------------------
resource "azurerm_role_assignment" "app_kv_reader" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.this.identity[0].principal_id
}
