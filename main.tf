resource "azurerm_resource_group" "lab_rg" {
  name     = "rg-lab-devsecops-francecentral"
  location = "francecentral"

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
    Owner       = "Jordan"
  }
}
