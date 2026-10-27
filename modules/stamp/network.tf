# -----------------------------------------------------------------------------
# Virtual Network
# -----------------------------------------------------------------------------
resource "azurerm_virtual_network" "this" {
  name                = "vnet-${var.stamp_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}

# -----------------------------------------------------------------------------
# Subnet pour l'intégration App Service
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "app_integration" {
  name                 = "snet-app-integration"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_app_integration_prefix]

  # Obligatoire pour que l'App Service puisse s'intégrer au VNet
  delegation {
    name = "app-service-delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# -----------------------------------------------------------------------------
# Subnet pour les Private Endpoints (SQL, Key Vault)
# -----------------------------------------------------------------------------
resource "azurerm_subnet" "private_endpoints" {
  name                 = "snet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_private_endpoints_prefix]
}
