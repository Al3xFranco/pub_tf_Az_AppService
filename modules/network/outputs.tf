output "app_subnet_id" {
    value = azurerm_subnet.app.id
}

output "private_endpoints_subnet_id" {
    value = azurerm_subnet.private_endpoints.id
}

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "keyvault_private_dns_zone_id" {
    value = azurerm_private_dns_zone.kv.id
}