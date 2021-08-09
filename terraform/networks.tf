##region-01============
resource "azurerm_virtual_network" "region-01" {
  name                = "${var.prefix}-vnet-region-01"
  address_space       = ["10.${var.region_octets[0]}.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

}
resource "azurerm_subnet" "region-01-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "region-01-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "region-01-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-01.name
  address_prefixes       = ["10.${var.region_octets[0]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-region-01" {
  name                = "${var.prefix}-rt-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = (var.deploy_routes && var.region-01_default_route) ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-region-01"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[0]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }


}

resource "azurerm_subnet_route_table_association" "rt-region-01" {
  subnet_id      = azurerm_subnet.region-01-private01.id
  route_table_id = azurerm_route_table.rt-region-01.id
}

#region-02==========================
resource "azurerm_virtual_network" "region-02" {
  name                = "${var.prefix}-vnet-region-02"
  address_space       = ["10.${var.region_octets[1]}.0.0/16"]
  location            = "westcentralus"
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "region-02-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-02.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "region-02-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-02.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "region-02-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-02.name
  address_prefixes       = ["10.${var.region_octets[1]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-region-02" {
  name                = "${var.prefix}-rt-region-02"
  location            = azurerm_virtual_network.region-02.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = var.deploy_routes ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-region-02"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[1]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt-region-02" {
  subnet_id      = azurerm_subnet.region-02-private01.id
  route_table_id = azurerm_route_table.rt-region-02.id
}
#region-03==========================
resource "azurerm_virtual_network" "region-03" {
  name                = "${var.prefix}-vnet-region-03"
  address_space       = ["10.${var.region_octets[2]}.0.0/16"]
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name
}
resource "azurerm_subnet" "region-03-public01" {
  name                 = "public01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-03.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[0]}.0/24"]
}

resource "azurerm_subnet" "region-03-azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-03.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[2]}.0/24"]
}

resource "azurerm_subnet" "region-03-private01" {
  name                 = "private01"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.region-03.name
  address_prefixes       = ["10.${var.region_octets[2]}.${var.subnet_octets[1]}.0/24"]
}

resource "azurerm_route_table" "rt-region-03" {
  name                = "${var.prefix}-rt-region-03"
  location            = azurerm_virtual_network.region-03.location
  resource_group_name = azurerm_resource_group.main.name
  dynamic "route" {
    for_each = var.deploy_routes ? toset([1]) : toset([])
    content {
          name                   = "${var.prefix}-rt-region-03"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.${var.region_octets[2]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
    }
  }

}

resource "azurerm_subnet_route_table_association" "rt-region-03" {
  subnet_id      = azurerm_subnet.region-03-private01.id
  route_table_id = azurerm_route_table.rt-region-03.id
}