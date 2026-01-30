output "keyvault_id" {
  value       = data.azurerm_key_vault.existing.id
  description = "Resource ID of the existing Key Vault"
}

output "keyvault_uri" {
  value       = data.azurerm_key_vault.existing.vault_uri
  description = "Vault URI"
}

output "private_endpoint_id" {
  value       = azurerm_private_endpoint.kv_pe.id
  description = "ID of the created Private Endpoint for Key Vault"
}