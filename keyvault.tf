# 1. Découverte dynamique de l'identité qui exécute Terraform (toi ou le Service Principal CI)
data "azurerm_client_config" "current" {}

# 2. Suffixe aléatoire pour garantir un nom mondialement unique au Key Vault
resource "random_string" "kv_suffix" {
  length  = 5
  special = false
  upper   = false
}

# 3. Déploiement d'Azure Key Vault (SKU Standard, économique pour étudiant)
resource "azurerm_key_vault" "kv" {
  name                        = "kv-secops-${random_string.kv_suffix.result}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = var.admin_ip_range
  }

  # Politique d'accès : autorise Terraform à écrire et lire les secrets du coffre
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge"
    ]
  }


  tags = local.common_tags
}

# 4. Génération d'un mot de passe fort (exigences strictes Azure PostgreSQL)
resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 2
  min_upper        = 2
  min_numeric      = 2
  min_special      = 2
}

# 5. Enregistrement direct du mot de passe dans Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name            = "db-admin-password"
  value           = random_password.db_password.result
  key_vault_id    = azurerm_key_vault.kv.id
  content_type    = "password"
  expiration_date = "2027-12-31T23:59:59Z"
}