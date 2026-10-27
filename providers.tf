terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "grp-terraform-data"
    storage_account_name = "stgaccountterrafomdata"
    container_name       = "tfstate"
    key                  = "platform.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
