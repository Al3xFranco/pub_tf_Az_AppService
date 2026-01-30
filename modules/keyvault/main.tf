# Look up manually-created Key Vault (control-plane call)
data "azurerm_key_vault" "existing" {
  name                = var.keyvault_name
  resource_group_name = var.keyvault_rg
}

# Private Endpoint for the existing Key Vault
resource "azurerm_private_endpoint" "kv_pe" {
  name                = "pe-${var.keyvault_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoints_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.keyvault_name}"
    private_connection_resource_id = data.azurerm_key_vault.existing.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "pdns-zg-kv"
    private_dns_zone_ids = [var.keyvault_private_dns_zone_id]
  }
}