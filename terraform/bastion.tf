##region-01============
resource "azurerm_public_ip" "bastion-region-01" {
  name                = "${var.prefix}-vnet-region-01-ip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "region-01" {
  name                = "${var.prefix}-bastion-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.region-01-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-region-01.id
  }
}
##region-02============
resource "azurerm_public_ip" "bastion-region-02" {
  name                = "${var.prefix}-vnet-region-02-ip"
  location            = "westcentralus"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
  availability_zone   = "No-Zone"
}

resource "azurerm_bastion_host" "region-02" {
  name                = "${var.prefix}-bastion-region-02"
  location            = azurerm_public_ip.bastion-region-02.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.region-02-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-region-02.id
  }
}
##region-03============
resource "azurerm_public_ip" "bastion-region-03" {
  name                = "${var.prefix}-vnet-region-03-ip"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "region-03" {
  name                = "${var.prefix}-bastion-region-03"
  location            = azurerm_public_ip.bastion-region-03.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.region-03-azurebastionsubnet.id
    public_ip_address_id = azurerm_public_ip.bastion-region-03.id
  }
}