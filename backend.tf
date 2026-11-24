# State distant, créé par scripts/bootstrap-backend.sh
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-secops-mgmt-polandcentral"
    storage_account_name = "stsecopsstate9ay5pp"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
    use_azuread_auth     = true
  }
}
