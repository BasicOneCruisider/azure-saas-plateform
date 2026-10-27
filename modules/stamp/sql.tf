# -----------------------------------------------------------------------------
# Serveur Azure SQL
# -----------------------------------------------------------------------------
resource "azurerm_mssql_server" "this" {
  name                          = local.sql_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sql_admin_login
  administrator_login_password  = var.sql_admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false # Aucun accès depuis Internet
  tags                          = var.tags
}

# -----------------------------------------------------------------------------
# Base de données Azure SQL
# -----------------------------------------------------------------------------
resource "azurerm_mssql_database" "this" {
  name      = "sqldb-${var.stamp_name}"
  server_id = azurerm_mssql_server.this.id
  sku_name  = var.sql_sku_name
  tags      = var.tags
}



# -----------------------------------------------------------------------------
# Lien VNet vers la zone DNS SQL partagée
# -----------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "vnet-link-sql-${var.stamp_name}" # Nom unique par stamp
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = "privatelink.database.windows.net"
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}

# -----------------------------------------------------------------------------
# Private Endpoint pour SQL (Utilise la zone DNS partagée)
# -----------------------------------------------------------------------------
resource "azurerm_private_endpoint" "sql" {
  name                = "pe-${local.sql_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoints.id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = azurerm_mssql_server.this.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.dns_zone_sql_id] # <-- Utilise la variable
  }
}
