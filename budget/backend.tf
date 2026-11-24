# State séparé de l'infra : le workflow Destroy ne supprime pas les alertes de budget.
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-secops-mgmt-polandcentral"
    storage_account_name = "stsecopsstate9ay5pp"
    container_name       = "tfstate"
    key                  = "budget.tfstate"
    use_azuread_auth     = true
  }
}
