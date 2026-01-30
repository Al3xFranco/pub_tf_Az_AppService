variable "location" {
  type    = string
  default = "westeurope"
}

variable "name_prefix" {
  description = "Prefix for resource naming"
  type        = string
}

variable "kv-rg" {
  description = "KeyVault Resource Group"
  type        = string
}

variable "kv-name" {
  description = "Keyvault Name"
  type        = string
}

variable "secret-uri" {
  description = "Secret Identifier"
  type        = string
}