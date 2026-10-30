resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}-${var.localisation}"
  location = var.localisation
  tags     = merge(local.common_tags, { Owner = "SecOps" })
}
