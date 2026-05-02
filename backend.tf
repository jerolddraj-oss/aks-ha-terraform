terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatejdaks123"
    container_name       = "tfstate"
    key                  = "aks-ha-${terraform.workspace}.tfstate"
  }
}