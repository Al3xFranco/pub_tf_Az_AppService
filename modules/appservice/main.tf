resource "azurerm_service_plan" "plan" {
  name                = "asp-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"

  # Portfolio note: use a cheaper tier if you want; P1v3 looks "enterprise".
  sku_name = "P1v3"

  tags = var.tags
}

resource "azurerm_linux_web_app" "app" {
  name                = "app-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on        = true
    ftps_state       = "Disabled"
    minimum_tls_version = "1.2"
  }

  app_settings = {
    # App Insights
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_str

    # Key Vault reference - resolves at runtime using Managed Identity
    "DEMO_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${var.existing_secret_uri})"
  }
}

# Outbound VNet integration (Swift)
resource "azurerm_app_service_virtual_network_swift_connection" "vnet" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = var.subnet_id_app
}

# Grant App's managed identity permission to read secrets
resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_web_app.app.identity[0].principal_id
}

# Diagnostics to Log Analytics (categories can vary by region/service)
resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = "diag-${var.name_prefix}-app"
  target_resource_id         = azurerm_linux_web_app.app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "AppServiceHTTPLogs" }
  enabled_log { category = "AppServiceConsoleLogs" }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}