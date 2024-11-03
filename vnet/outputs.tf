output "subnet_ids" {
  value = module.my-app-vnet.vnet_subnets_name_id
}

output "vnet_id" {
  value = module.my-app-vnet.vnet_id
}
