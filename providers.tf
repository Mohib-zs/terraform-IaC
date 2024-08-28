provider "azurerm" {
  features {}

  skip_provider_registration = true
  subscription_id   = var.subscription_id
}