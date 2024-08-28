output "public_ip" {
  value = module.my-app-subnet.public_ip_address.ip_address
}