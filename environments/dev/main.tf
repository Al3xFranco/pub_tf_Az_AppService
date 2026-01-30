locals {
    tags = {
        project = "secure-azure-appservice"
        owner   = "Alexandre"
        env     = "dev"
    }
}

resource "azurerm_resource_group" "rg" {
  name      = "rg-${var.name_prefix}"
  location  = var.location
  tags      = local.tags
}

module "network" {
    source              = "../../modules/network"
    name_prefix         = var.name_prefix
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags                 = local.tags
}

module "obs" {
    source              = "../../modules/observability"
    name_prefix         = var.name_prefix
    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags                = local.tags
}

module "keyvault" {
    source              = "../../modules/keyvault"
    keyvault_name       = var.kv-name
    keyvault_rg         = var.kv-rg

    location            = var.location
    resource_group_name = azurerm_resource_group.rg.name
    tags                = local.tags

    private_endpoints_subnet_id  = module.network.private_endpoints_subnet_id
    keyvault_private_dns_zone_id = module.network.keyvault_private_dns_zone_id
}

module "app" {
  source              = "../../modules/appservice"
  name_prefix         = var.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags

  subnet_id_app               = module.network.app_subnet_id
  log_analytics_workspace_id  = module.obs.log_analytics_id
  app_insights_connection_str = module.obs.app_insights_connection_string

  keyvault_id  = module.keyvault.keyvault_id
  existing_secret_uri = var.secret-uri
}