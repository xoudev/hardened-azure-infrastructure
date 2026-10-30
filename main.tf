resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.project_name}-${var.environment}-${var.localisation}"
  location = var.localisation
  tags = {
    environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = var.vnet_cidr
  tags                = azurerm_resource_group.rg.tags
}

resource "azurerm_subnet" "snet_private" {
  name                 = "snet-workload-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.private_subnet_cidr
}

resource "azurerm_network_security_group" "nsg_private" {
  name                = "nsg-${var.project_name}-private"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Deny-Internet-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
  

  tags = azurerm_resource_group.rg.tags
}

resource "azurerm_subnet_network_security_group_association" "private_sub_nsg_assoc" {
  subnet_id                 = azurerm_subnet.snet_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}