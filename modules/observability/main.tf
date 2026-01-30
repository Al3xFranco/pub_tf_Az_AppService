resource "azurerm_log_analytics_workspace" "law" {
    name                = "law-${var.name_prefix}"
    location            = var.location
    resource_group_name = var.resource_group_name
    sku                 = "PerGB2018"
    retention_in_days   = 30
    tags                = var.tags
}

resource "azurerm_application_insights" "appi" {
    name                = "appi-${var.name_prefix}"
    location            = var.location
    resource_group_name = var.resource_group_name
    application_type    = "web"
    workspace_id        = azurerm_log_analytics_workspace.law.id
    tags                = var.tags
}