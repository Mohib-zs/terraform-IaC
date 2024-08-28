output "public_ip_address" {
  value = data.azurerm_public_ip.my-app.ip_address
}
