output "public_ip_address" {
  value = azurerm_public_ip.my-app
}

output "network_interface" {
  value = azurerm_network_interface.my-app
}

