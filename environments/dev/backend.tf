terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "noxtfstate"
    container_name       = "tfstateappsrv"
    key                  = "secure-appservice-dev.tfstate"
  }
}