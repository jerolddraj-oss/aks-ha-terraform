resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  kubernetes_version = null

  default_node_pool {
    name            = "system"
    node_count      = 1
    vm_size         = var.vm_size
    vnet_subnet_id  = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  # ✅ NEW (replaces role_based_access_control block)
  role_based_access_control_enabled = true

  # ✅ NEW (replaces addon_profile.oms_agent)
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }

  # ✅ NEW (replaces addon_profile.azure_policy)
  azure_policy_enabled = true

  network_profile {
    network_plugin = "azure"
  }
}
