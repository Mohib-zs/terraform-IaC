provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id   = var.subscription_id
  tenant_id         = var.tenant_id
}

resource "azurerm_resource_group" "my-app-rg" {
    name = var.resource_group_name
    location = var.location
}