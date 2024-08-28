module "my-app-subnet" {
  source               = "./modules/subnet"
  subnet_cidr_block    = var.subnet_cidr_block
  location             = var.location
  virtual_network_name = module.my-app-server.virtual_network.name 
  env_prefix           = var.env_prefix
  my_ip                = var.my_ip
  resource_group_name  = module.my-app-server.resource_group_name.name
}

module "my-app-server" {
  source                = "./modules/webserver"
  env_prefix            = var.env_prefix
  location              = var.location
  vnet_cidr_block       = var.vnet_cidr_block
  vm_size               = var.vm_size
  vm_username           = var.vm_username
  network_interface_id  = module.my-app-subnet.network_interface.id
  public_key_location   = var.public_key_location
}





