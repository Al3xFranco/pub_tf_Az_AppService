variable "keyvault_name" {
  type        = string
  description = "Name of the existing Key Vault"
}

variable "keyvault_rg" {
  type        = string
  description = "Resource group of the existing Key Vault"
}

variable "location" {
  type        = string
  description = "Region for the Private Endpoint"
}

variable "resource_group_name" {
  type        = string
  description = "RG where the Private Endpoint will be created"
}

variable "tags" {
  type        = map(string)
  description = "Common tags"
}

variable "private_endpoints_subnet_id" {
  type        = string
  description = "Subnet ID where the Key Vault Private Endpoint will be created"
}

variable "keyvault_private_dns_zone_id" {
  type        = string
  description = "ID of the 'privatelink.vaultcore.azure.net' Private DNS Zone (from the network module)"
}