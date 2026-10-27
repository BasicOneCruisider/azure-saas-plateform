variable "location" {
  description = "Région Azure pour le stamp primaire."
  type        = string
  default     = "swedencentral"
}

variable "stamp_name" {
  description = "Nom du stamp primaire."
  type        = string
  default     = "swedcent-01"
}
variable "resource_group_name" {
  description = "Nom du groupe de ressources qui contiendra le stamp."
  type        = string
  default     = "rg-saas-platform-prod"
}

variable "sql_admin_password" {
  description = "Mot de passe admin pour la base de données SQL."
  type        = string
  sensitive   = true
}

variable "app_service_sku_name" {
  description = "SKU du plan App Service."
  type        = string
  default     = "F1" # On passe en gratuit pour contourner le quota à 0 du B1
}
variable "dr_location" {
  description = "Région Azure pour le stamp secondaire (DR)."
  type        = string
  default     = "westus2"
}

variable "dr_stamp_name" {
  description = "Nom du stamp secondaire (DR)."
  type        = string
  default     = "westus2-02"
}
