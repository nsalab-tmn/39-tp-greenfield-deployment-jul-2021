##EASTUS============
resource "azurerm_public_ip" "bastion-eastus" {
  name                = "${var.prefix}-vnet-eastus-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "eastus" {
  name                = "${var.prefix}-bastion-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.eastus-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-eastus.id
  }
}
##WESTUS============
resource "azurerm_public_ip" "bastion-westus" {
  name                = "${var.prefix}-vnet-westus-ip"
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"
}

resource "azurerm_bastion_host" "westus" {
  name                = "${var.prefix}-bastion-westus"
  location            = azurerm_public_ip.bastion-westus.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.westus-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-westus.id
  }
}
##SOUTHCENTRALUS============
resource "azurerm_public_ip" "bastion-southcentralus" {
  name                = "${var.prefix}-vnet-southcentralus-ip"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "southcentralus" {
  name                = "${var.prefix}-bastion-southcentralus"
  location            = azurerm_public_ip.bastion-southcentralus.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.southcentralus-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-southcentralus.id
  }
}