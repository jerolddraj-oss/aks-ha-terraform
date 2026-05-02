variable "resource_group_name" {
  description = "Resource group name"
  default     = "aks-ha-rg"
}

variable "regions" {
  description = "Regions map"
  default = {
    hub  = "East US"
    asia = "Southeast Asia"
    au   = "Australia East"
  }
}

variable "tags" {
  description = "Tags"
  default = {
    environment = "prod"
    project     = "aks-ha"
  }
}