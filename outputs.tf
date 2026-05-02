output "clusters" {
  value = {
    us   = module.aks_us.name
    asia = module.aks_asia.name
    au   = module.aks_au.name
  }
}