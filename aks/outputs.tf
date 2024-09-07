output "aks_cluster_name" {
  value = module.my-app-aks.aks_name
}

output "aks_cluster_kubeconfig" {
  value     = module.my-app-aks.kube_config_raw
  sensitive = true
}