# State distant, créé par scripts/bootstrap-backend.sh
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-secops-mgmt-germanywestcentral"
    storage_account_name = "stsecopsstateyk4u36"
    container_name       = "tfstate"
    key                  = "infrastructure.tfstate"
    use_azuread_auth     = true
  }
}
