output "gateway_ips" {
  value = azurerm_public_ip.nat_gateway_ip.ip_address 
}

output "nat_gateway_id" {
    value = azurerm_nat_gateway.nat_gateway
}

output "subnet_ids" {
    value = module.my-app-vnet.vnet_subnets_name_id
}

