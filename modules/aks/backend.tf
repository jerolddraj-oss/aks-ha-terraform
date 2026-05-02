terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"        # <-- your RG where storage exists
    storage_account_name = "jdterraformstate"  # ✅ your storage account
    container_name       = "tfstate"           # ✅ your container
  }
}
