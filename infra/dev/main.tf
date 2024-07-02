terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "<= 3.104.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "dev-lorenzo"
    storage_account_name = "devlorenzosa"
    container_name       = "azurermstatelorenzo"
    key                  = "lorenzo-infra.identity.dev.westeurope.tfstate"
  }
}
provider "azurerm" {
  features {}
}
data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}