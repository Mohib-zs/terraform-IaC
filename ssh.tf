resource "tls_private_key" "app_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content  = tls_private_key.app_ssh_key.private_key_pem
  filename = var.private_key_location     # Save the private key as dev_id_rsa
}

resource "local_file" "public_key" {
  content  = tls_private_key.app_ssh_key.public_key_openssh
  filename = var.public_key_location      # Save the public key as dev_id_rsa.pub
}