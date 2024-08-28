locals {
  custom_data = <<CUSTOM_DATA
#!/bin/bash
sudo -i
cat << EOF > /etc/customdata.sh
sudo apt update && sudo apt -y upgrade
sudo apt install -y docker.io
sudo systemctl start docker
sudo usermod -aG docker devuser
docker run -p 8080:80 nginx 
EOF
chmod +x /etc/customdata.sh
sudo /etc/customdata.sh
CUSTOM_DATA

#   user_data = file("startup-script.sh")
}

resource "azurerm_resource_group" "my-app" {
  name     = "${var.env_prefix}-resources"
  location = var.location
}

resource "azurerm_virtual_network" "my-app" {
  name                = "${var.env_prefix}-vnet"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  address_space       = [var.vnet_cidr_block]
}


resource "azurerm_linux_virtual_machine" "my-app" {
  name                = "${var.env_prefix}-machine"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  size                = var.vm_size
  admin_username      = var.vm_username
  custom_data         = base64encode(file("startup-script.sh"))
  network_interface_ids = [
    var.network_interface_id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = file(var.public_key_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

}
