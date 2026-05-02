resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.regions["hub"]
  tags     = var.tags
}

# Log Analytics
resource "azurerm_log_analytics_workspace" "law" {
  name                = "aks-law-${terraform.workspace}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

# HUB
module "hub" {
  source              = "./modules/network"
  vnet_name           = "hub-vnet"
  location            = var.regions["hub"]
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefix       = ["10.0.1.0/24"]
}

# SPOKES
module "asia" {
  source              = "./modules/network"
  vnet_name           = "spoke-asia"
  location            = var.regions["asia"]
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
  subnet_prefix       = ["10.1.1.0/24"]
}

module "au" {
  source              = "./modules/network"
  vnet_name           = "spoke-au"
  location            = var.regions["au"]
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.2.0.0/16"]
  subnet_prefix       = ["10.2.1.0/24"]
}

# VNET PEERING
resource "azurerm_virtual_network_peering" "hub_asia" {
  name                      = "hub-asia"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.asia.vnet_id
}

resource "azurerm_virtual_network_peering" "asia_hub" {
  name                      = "asia-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.asia.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}

resource "azurerm_virtual_network_peering" "hub_au" {
  name                      = "hub-au"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.hub.vnet_name
  remote_virtual_network_id = module.au.vnet_id
}

resource "azurerm_virtual_network_peering" "au_hub" {
  name                      = "au-hub"
  resource_group_name       = azurerm_resource_group.rg.name
  virtual_network_name      = module.au.vnet_name
  remote_virtual_network_id = module.hub.vnet_id
}

# AKS
module "aks_us" {
  source              = "./modules/aks"
  name                = "aks-us"
  location            = var.regions["hub"]
  subnet_id           = module.hub.subnet_id
  log_analytics_id    = azurerm_log_analytics_workspace.law.id
  resource_group_name = azurerm_resource_group.rg.name

  vm_size = "Standard_DC2s_v3"   # ✅ East US (your subscription allows DC-series)
}

module "aks_asia" {
  source              = "./modules/aks"
  name                = "aks-asia"
  location            = var.regions["asia"]
  subnet_id           = module.asia.subnet_id
  log_analytics_id    = azurerm_log_analytics_workspace.law.id
  resource_group_name = azurerm_resource_group.rg.name

  vm_size = "Standard_B2s_v2"   # ✅ Asia
}

module "aks_au" {
  source              = "./modules/aks"
  name                = "aks-au"
  location            = var.regions["au"]
  subnet_id           = module.au.subnet_id
  log_analytics_id    = azurerm_log_analytics_workspace.law.id
  resource_group_name = azurerm_resource_group.rg.name

  vm_size = "Standard_B2s_v2"   # ✅ Australia
}
