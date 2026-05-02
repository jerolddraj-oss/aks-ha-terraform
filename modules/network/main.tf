resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefix
}

resource "azurerm_route_table" "rt" {
  name                = "${var.vnet_name}-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_route_table_association" "assoc" {
  subnet_id      = azurerm_subnet.aks.id
  route_table_id = azurerm_route_table.rt.id
}