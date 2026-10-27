# Suffixe aléatoire pour garantir l'unicité globale des noms (App Service, SQL, KV)
data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

locals {
  suffix = random_string.suffix.result

  # Noms standardisés pour les ressources du stamp
  kv_name  = "kv-${var.stamp_name}-${local.suffix}"
  sql_name = "sql-${var.stamp_name}-${local.suffix}"
  app_name = "app-${var.stamp_name}-${local.suffix}"
}
