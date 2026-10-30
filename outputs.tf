output "resource_group_name" {
  description = "Nom du Resource Group provisionné"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "Identifiant ARM du Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  description = "Identifiant ARM du sous-réseau privé durci"
  value       = azurerm_subnet.snet_private.id
}

output "nsg_id" {
  description = "Identifiant ARM du Network Security Group"
  value       = azurerm_network_security_group.nsg_private.id
}