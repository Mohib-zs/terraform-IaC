resource "azurerm_subnet" "my-app" {
  name                 = "${var.env_prefix}-subnet-1"
  resource_group_name  = var.resource_group_name 
  virtual_network_name = var.virtual_network_name 
  address_prefixes     = [var.subnet_cidr_block]
}

resource "azurerm_subnet_route_table_association" "my-app" {
  subnet_id      = azurerm_subnet.my-app.id  
  route_table_id = azurerm_route_table.my-app.id  
}

resource "azurerm_route_table" "my-app" {
  name                = "${var.env_prefix}-route-table"
  location            = var.location 
  resource_group_name = var.resource_group_name

  route {
    name           = "route1"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

resource "azurerm_network_security_group" "my-app" {
  name                = "${var.env_prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.my_ip
    destination_address_prefix = "*"
  }
  
  security_rule {
    name                       = "web-host"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }  

}

resource "azurerm_network_interface" "my-app" {
  name                = "${var.env_prefix}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.my-app.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my-app.id
  }
}

resource "azurerm_network_interface_security_group_association" "my-app" {
  network_interface_id      = azurerm_network_interface.my-app.id
  network_security_group_id = azurerm_network_security_group.my-app.id
}

resource "azurerm_public_ip" "my-app" {
  name                = "${var.env_prefix}-public-ip"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

data "azurerm_public_ip" "my-app" {
  name                = azurerm_public_ip.my-app.name
  resource_group_name = var.resource_group_name
}

