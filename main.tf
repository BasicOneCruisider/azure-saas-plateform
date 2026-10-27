# ---------------------------------------------------------
# ZONES DNS PARTAGÉES (Créées une seule fois pour tous les stamps)
# ---------------------------------------------------------
resource "azurerm_private_dns_zone" "vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

# Création du Resource Group principal







resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

# Appel de notre module "stamp" pour la région primaire
module "stamp_primary" {
  source = "./modules/stamp"

  stamp_name          = var.stamp_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  environment         = "prod"
  dns_zone_vault_id   = azurerm_private_dns_zone.vault.id
  dns_zone_sql_id     = azurerm_private_dns_zone.sql.id


  depends_on = [
    azurerm_private_dns_zone.vault,
    azurerm_private_dns_zone.sql
  ]

  # On passe le mot de passe SQL défini à la racine vers le module
  sql_admin_password = var.sql_admin_password

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }

}

# Appel de notre module "stamp" pour la région secondaire (DR)
module "stamp_secondary" {
  source = "./modules/stamp"

  stamp_name          = var.dr_stamp_name
  location            = var.dr_location
  resource_group_name = azurerm_resource_group.this.name
  environment         = "prod"
  dns_zone_vault_id   = azurerm_private_dns_zone.vault.id
  dns_zone_sql_id     = azurerm_private_dns_zone.sql.id

  depends_on = [
    azurerm_private_dns_zone.vault,
    azurerm_private_dns_zone.sql,
    module.stamp_primary
  ]


  # On réutilise le même mot de passe
  sql_admin_password = var.sql_admin_password

  tags = {
    Environment = "prod"
    Role        = "DR"
    ManagedBy   = "Terraform"
  }
}
