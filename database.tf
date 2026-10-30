#trivy:ignore:AZU-0021 Paramètre connection_throttling non supporté sur PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "PostgreSQL_fs" {
  name                          = "psql-secops-${random_string.kv_suffix.result}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  administrator_login           = "secopsadmin"
  administrator_password        = random_password.db_password.result
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  version                       = "16"
  delegated_subnet_id           = azurerm_subnet.subnet_db.id
  private_dns_zone_id           = azurerm_private_dns_zone.private_dns.id
  public_network_access_enabled = false

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_link]

  tags = local.common_tags
}

resource "azurerm_postgresql_flexible_server_database" "db_app" {
  name      = "secops_db"
  server_id = azurerm_postgresql_flexible_server.PostgreSQL_fs.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_configuration" "log_connections" {
  server_id = azurerm_postgresql_flexible_server.PostgreSQL_fs.id
  name      = "log_connections"
  value     = "on"
}



resource "azurerm_postgresql_flexible_server_configuration" "log_checkpoints" {
  server_id = azurerm_postgresql_flexible_server.PostgreSQL_fs.id
  name      = "log_checkpoints"
  value     = "on"
}