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

  user_data = file("startup-script.sh")
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

module "my-app-subnet" {
  source               = "./modules/subnet"
  subnet_cidr_block    = var.subnet_cidr_block
  location             = var.location
  virtual_network_name = azurerm_virtual_network.my-app.name 
  env_prefix           = var.env_prefix
  my_ip                = var.my_ip
  resource_group_name  = azurerm_resource_group.my-app.name
}

resource "azurerm_linux_virtual_machine" "my-app" {
  name                = "${var.env_prefix}-machine"
  resource_group_name = azurerm_resource_group.my-app.name
  location            = azurerm_resource_group.my-app.location
  size                = var.vm_size
  admin_username      = var.vm_username
  # user_data           = base64encode(local.user_data)
  network_interface_ids = [
    module.my-app-subnet.network_interface.id,
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

data "azurerm_public_ip" "my-app" {
  name                = module.my-app-subnet.public_ip_address.name
  resource_group_name = azurerm_resource_group.my-app.name
}



