##EASTUS============
resource "azurerm_virtual_network" "eastus" {
  name                = "${var.prefix}-vnet-eastus"
  address_space       = ["10.${var.region_octets[0]}.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

}
resource "azurerm_subnet" "eastus-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.eastus.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "eastus-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.eastus.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "eastus-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.eastus.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-eastus" {
  name                = "${var.prefix}-rt-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = var.deploy_routes && !var.delete_eastus_default_route ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-eastus"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[0]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }


}

resource "azurerm_subnet_route_table_association" "rt-eastus" {
  subnet_id      = azurerm_subnet.eastus-private01.id
  route_table_id = azurerm_route_table.rt-eastus.id
}

#WESTUS==========================
resource "azurerm_virtual_network" "westus" {
  name                = "${var.prefix}-vnet-westus"
  address_space       = ["10.${var.region_octets[1]}.0.0/16"]
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "westus-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.westus.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "westus-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.westus.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "westus-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.westus.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-westus" {
  name                = "${var.prefix}-rt-westus"
  location            = azurerm_virtual_network.westus.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = var.deploy_routes ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-westus"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[1]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt-westus" {
  subnet_id      = azurerm_subnet.westus-private01.id
  route_table_id = azurerm_route_table.rt-westus.id
}
#SOUTHCENTRALUS==========================
resource "azurerm_virtual_network" "southcentralus" {
  name                = "${var.prefix}-vnet-southcentralus"
  address_space       = ["10.${var.region_octets[2]}.0.0/16"]
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "southcentralus-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.southcentralus.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "southcentralus-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.southcentralus.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "southcentralus-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.southcentralus.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-southcentralus" {
  name                = "${var.prefix}-rt-southcentralus"
  location            = azurerm_virtual_network.southcentralus.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = var.deploy_routes ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-southcentralus"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[2]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }

}

resource "azurerm_subnet_route_table_association" "rt-southcentralus" {
  subnet_id      = azurerm_subnet.southcentralus-private01.id
  route_table_id = azurerm_route_table.rt-southcentralus.id
}