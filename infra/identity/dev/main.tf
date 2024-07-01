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
    key                  = "lorenzo-infra.identity.prod.westeurope.tfstate.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "federated_identities" {
  source = "github.com/pagopa/dx//infra/modules/azure_federated_identity_with_github?ref=main"

  prefix       = local.prefix
  env_short    = local.env_short
  env          = "dev"
  domain       = local.domain
  repositories = [local.repo_name]
  tags         = local.tags

  continuos_delivery = {
    enable = true
    roles = {
      subscription = ["Contributor"]
      resource_groups = {
        terraform-state-rg = [
          "Storage Blob Data Contributor"
        ],
        # TODO fix data rg
        # ts-p-itn-data-rg-01 = [
        #   "Role Based Access Control Administrator"
        # ]
      }
    }
  }
}

module "app_federated_identities" {
  source = "github.com/pagopa/dx//infra/modules/azure_federated_identity_with_github?ref=main"

  prefix       = local.prefix
  env_short    = local.env_short
  env          = "app-prod"
  domain       = "${local.domain}-app"
  repositories = [local.repo_name]
  tags         = local.tags
}
