variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "subnet_id" {}
variable "log_analytics_id" {}

# ✅ ADD THIS
variable "vm_size" {
  description = "VM size for AKS node pool"
  type        = string
}
