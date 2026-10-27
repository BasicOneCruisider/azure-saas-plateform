# -----------------------------------------------------------------------------
# Identité du Stamp
# -----------------------------------------------------------------------------
variable "stamp_name" {
  description = "Nom logique du stamp (ex: 'weu-01' pour West Europe 1). Sert de préfixe/suffixe."
  type        = string
}

variable "location" {
  description = "Région Azure où déployer ce stamp (ex: 'westeurope')."
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources qui contiendra toutes les ressources du stamp."
  type        = string
}

variable "environment" {
  description = "Environnement de déploiement (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "tags" {
  description = "Tags à appliquer à toutes les ressources du stamp."
  type        = map(string)
  default     = {}
}

# -----------------------------------------------------------------------------
# Réseau
# -----------------------------------------------------------------------------
variable "vnet_address_space" {
  description = "Plage d'adresses IP pour le VNet du stamp."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_app_integration_prefix" {
  description = "Plage d'adresses pour le subnet d'intégration VNet de l'App Service."
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_private_endpoints_prefix" {
  description = "Plage d'adresses pour le subnet des Private Endpoints (SQL, Key Vault)."
  type        = string
  default     = "10.0.2.0/24"
}

# -----------------------------------------------------------------------------
# Azure SQL
# -----------------------------------------------------------------------------
variable "sql_admin_login" {
  description = "Nom d'utilisateur admin pour le serveur SQL."
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "Mot de passe admin pour le serveur SQL."
  type        = string
  sensitive   = true
}

variable "sql_sku_name" {
  description = "SKU du serveur SQL (ex: 'S0' pour dev, 'P1' pour prod)."
  type        = string
  default     = "S0"
}

# -----------------------------------------------------------------------------
# App Service
# -----------------------------------------------------------------------------
variable "app_service_sku_name" {
  description = "SKU du plan App Service (ex: 'B1' pour dev, 'P1v3' pour prod)."
  type        = string
  default     = "B1"
}

variable "dns_zone_vault_id" {
  description = "ID de la zone DNS privée partagée pour Key Vault"
  type        = string
}

variable "dns_zone_sql_id" {
  description = "ID de la zone DNS privée partagée pour SQL"
  type        = string
}
