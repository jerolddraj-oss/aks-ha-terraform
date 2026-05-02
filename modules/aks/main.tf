resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  kubernetes_version = null

  default_node_pool {
    name            = "system"
    node_count      = 2
    vm_size         = var.vm_size
    vnet_subnet_id  = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  # ✅ RBAC (v3 syntax)
  role_based_access_control_enabled = true

  # ✅ FIX 1: OIDC must be enabled (Azure default)
  oidc_issuer_enabled = true

  # ✅ Monitoring
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }

  # ✅ Azure Policy
  azure_policy_enabled = true

  # ✅ FIX 2: Avoid CIDR overlap with VNet
  network_profile {
    network_plugin = "azure"

    service_cidr   = "10.100.0.0/16"
    dns_service_ip = "10.100.0.10"
  }
}
