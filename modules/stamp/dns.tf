# -----------------------------------------------------------------------------
# Liens VNet vers les zones DNS partagées
# -----------------------------------------------------------------------------
resource "azurerm_private_dns_zone_virtual_network_link" "vault" {
  name                  = "vnet-link-kv-${var.stamp_name}" # Nom unique par stamp
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = "privatelink.vaultcore.azure.net"
  virtual_network_id    = azurerm_virtual_network.this.id
  registration_enabled  = false
  tags                  = var.tags
}
