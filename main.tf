provider "azurerm" {
  features {}

  skip_provider_registration = true
  subscription_id   = var.subscription_id
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

variable "subscription_id" {
  type = string
}


variable "subnet_cidr_block" {
  type        = string
  default     = "10.1.2.0/24"
  description = "subnet cidr block"
}

variable "cidr_block" {
  type        = list(string)
  description = "cidr block made for multiple subnets"
}

variable "cidr_blocks" {
  description = "cidr block for multiple subnets"
  type        = list(object({
    cidr_block = string
    name = string
  }))
}

data "azurerm_virtual_network" "existing" {
  name                = "docker-vm-vnet"
  resource_group_name = "dockerVm"
}

resource "azurerm_subnet" "existing" {
  name                 = var.cidr_blocks[0].name
  resource_group_name  = data.azurerm_virtual_network.existing.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  address_prefixes     = [var.cidr_blocks[0].cidr_block]
}


