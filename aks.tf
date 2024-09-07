data "azurerm_kubernetes_cluster" "default" {
  depends_on          = [module.my-app-aks.aks_name] # refresh cluster state before reading
  name                = module.my-app-aks.aks_name
  resource_group_name = var.resource_group_name
}

module "my-app-aks" {
  source  = "Azure/aks/azurerm"
  version = "9.1.0"

  resource_group_name                 = var.resource_group_name
  prefix                              = "my-app"

  vnet_subnet_id                      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-1"]
  enable_auto_scaling                 = true
  agents_pool_name                    = "default"
  agents_min_count                    = 1
  agents_max_count                    = 2
  agents_size                         = var.vm_size
  agents_type                         = "VirtualMachineScaleSets"
  agents_availability_zones           = ["1"]
  agents_max_pods                     = 30
  agents_labels = {
    "node-type" = "default"
  }
  agents_tags = {
    "Agent" = "default"
  }

  network_plugin                                = "azure"
  network_policy                                = "azure"
  net_profile_dns_service_ip                    = "10.1.0.10"
  net_profile_service_cidr                      = "10.1.0.0/16"
  load_balancer_sku                             = "standard"
  net_profile_outbound_type                     = "userAssignedNATGateway"
  
  depends_on = [
    azurerm_subnet_nat_gateway_association.subnet_nat_associations
  ]

  role_based_access_control_enabled             = true 
  rbac_aad                                      = true
  rbac_aad_managed                              = true  

  node_pools = {
    pool2 = {
      name                = "pool2"
      vnet_subnet_id      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-2"]
      vm_size             = var.vm_size
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 2
      availability_zones  = ["2"]
    }
    pool3 = {
      name                = "pool3"
      vnet_subnet_id      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-3"]
      vm_size             = var.vm_size
      enable_auto_scaling = true
      min_count           = 1
      max_count           = 2
      availability_zones  = ["3"]      
    }
    # spot1 = {
    #   name                = "spot1"
    #   vnet_subnet_id      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-1"]
    #   vm_size             = var.vm_size
    #   min_count           = 1
    #   max_count           = 2
    #   priority            = "Spot"
    #   eviction_policy     = "Delete"
    #   spot_max_price      = -1
    #   node_taints         = ["workload=spot:NoSchedule"]
    #   node_labels         = { "workload" = "spot" }
    #   enable_auto_scaling = true
    #   max_pods            = 30
    #   os_disk_size_gb     = 30
    #   availability_zones  = ["1"]
    # }
    # spot2 = {
    #   name                = "spot2"
    #   vnet_subnet_id      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-2"]
    #   vm_size             = var.vm_size
    #   min_count           = 1
    #   max_count           = 2
    #   priority            = "Spot"
    #   eviction_policy     = "Delete"
    #   spot_max_price      = -1
    #   node_taints         = ["workload=spot:NoSchedule"]
    #   node_labels         = { "workload" = "spot" }
    #   enable_auto_scaling = true
    #   max_pods            = 30
    #   os_disk_size_gb     = 30
    #   availability_zones  = ["2"]
    # }
    # spot3 = {
    #   name                = "spot3"
    #   vnet_subnet_id      = module.my-app-vnet.vnet_subnets_name_id["private-subnet-3"]
    #   vm_size             = var.vm_size
    #   min_count           = 1
    #   max_count           = 2
    #   priority            = "Spot"
    #   eviction_policy     = "Delete"
    #   spot_max_price      = -1
    #   node_taints         = ["workload=spot:NoSchedule"]
    #   node_labels         = { "workload" = "spot" }
    #   enable_auto_scaling = true
    #   max_pods            = 30
    #   os_disk_size_gb     = 30
    #   availability_zones  = ["3"]
    # }
  }
}

# Outputs
output "aks_cluster_name" {
  value = module.my-app-aks.aks_name
}

output "aks_cluster_kubeconfig" {
  value     = module.my-app-aks.kube_config_raw
  sensitive = true
}


