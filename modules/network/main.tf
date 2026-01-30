resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-${var.name_prefix}"
    location            = var.location
    resource_group_name = var.resource_group_name
    address_space       = [ "10.10.0.0/16" ]
    tags                = var.tags
}

resource "azurerm_subnet" "app" {
    name                    = "snet-app"
    resource_group_name     = var.resource_group_name
    virtual_network_name    = azurerm_virtual_network.vnet.name
    address_prefixes        = ["10.10.1.0/24"]

    delegation {
      name = "delegation-appservice"
      service_delegation {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    }
}

resource "azurerm_subnet" "private_endpoints" {
    name                    = "snet-private-endpoints"
    resource_group_name     = var.resource_group_name
    virtual_network_name    = azurerm_virtual_network.vnet.name
    address_prefixes        = ["10.10.2.0/24"]

    private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_dns_zone" "kv" {
    name                = "privatelink.vaultcore.azure.net"
    resource_group_name = var.resource_group_name
    tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "kv_link" {
    name                    = "pdnslink-${var.name_prefix}-kv"
    resource_group_name     = var.resource_group_name
    private_dns_zone_name   = azurerm_private_dns_zone.kv.name
    virtual_network_id      = azurerm_virtual_network.vnet.id
    registration_enabled    = false
    tags                    = var.tags
}