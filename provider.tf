terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-secops-mgmt-germanywestcentral"
    storage_account_name = "stsecopsstateyk4u36"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
    use_azuread_auth     = true
  }
}

provider "azurerm" {
  features {}
}