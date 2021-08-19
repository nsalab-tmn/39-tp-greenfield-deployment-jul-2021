##region-01============
resource "azurerm_network_interface" "gw-region-01" {
  name                = "gw-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-01-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[0]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "gw-region-01-public" {
  name                = "gw-region-01-public"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.region-01-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[0]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.gw-region-01.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "gw-region-01" {
  name                    = "gw-region-01-public"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "gw-region-01" {
#   name                = "gw-region-01-public"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   security_rule {
#     name                       = "All"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#     access                     = "Allow"
#     priority                   = 1020
#     direction                  = "Inbound"
#   }
# }
# resource "azurerm_network_interface_security_group_association" "gw-region-01" {
#   network_interface_id      = azurerm_network_interface.gw-region-01-public.id
#   network_security_group_id = azurerm_network_security_group.gw-region-01.id
# }


resource "azurerm_linux_virtual_machine" "gw-region-01" {
  name                = "gw-region-01"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  plan {
    name      = "17_2_1-payg-sec"
    product   = "cisco-csr-1000v"
    publisher = "cisco"
  }
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "gw-region-01"
  network_interface_ids = [
    azurerm_network_interface.gw-region-01-public.id,
    azurerm_network_interface.gw-region-01.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "gw-region-01"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-gw-region-01.tpl", { westip = azurerm_public_ip.gw-region-02.ip_address, southip = azurerm_public_ip.gw-region-03.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-gw-region-01.tpl", { 
    westip = azurerm_public_ip.gw-region-02.ip_address, 
    southip = azurerm_public_ip.gw-region-03.ip_address,
    priv_ubuntu=azurerm_network_interface.platform-region-01.private_ip_address, priv_network=cidrhost(azurerm_subnet.region-01-private01.address_prefixes[0],0),
    adminuser=var.adminuser,
    password=random_string.pass.result })):null
}
##region-02============
resource "azurerm_network_interface" "gw-region-02" {
  name                = "gw-region-02"
  location            = "westcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-02-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[1]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "gw-region-02-public" {
  name                = "gw-region-02-public"
  location            = azurerm_network_interface.gw-region-02.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.region-02-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[1]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.gw-region-02.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "gw-region-02" {
  name                    = "gw-region-02-public"
  location                = azurerm_network_interface.gw-region-02.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "gw-region-02" {
#   name                = "gw-region-02-public"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   security_rule {
#     name                         = "All"
#     protocol                     = "*"
#     source_port_ranges           = ["*"]
#     destination_port_ranges      = ["*"]
#     source_address_prefixes      = ["*"]
#     destination_address_prefixes = ["*"]
#     access                       = "Allow"
#     priority                     = 1020
#     direction                    = "Inbound"
#   }
# }
# resource "azurerm_network_interface_security_group_association" "gw-region-02" {
#   network_interface_id      = azurerm_network_interface.gw-region-02-public.id
#   network_security_group_id = azurerm_network_security_group.gw-region-02.id
# }


resource "azurerm_linux_virtual_machine" "gw-region-02" {
  name                = "gw-region-02"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_network_interface.gw-region-02.location
  plan {
    name      = "17_2_1-payg-sec"
    product   = "cisco-csr-1000v"
    publisher = "cisco"
  }
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "gw-region-02"
  network_interface_ids = [
    azurerm_network_interface.gw-region-02-public.id,
    azurerm_network_interface.gw-region-02.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "gw-region-02"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-gw-region-02.tpl", { eastip = azurerm_public_ip.gw-region-01.ip_address, southip = azurerm_public_ip.gw-region-03.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-gw-region-02.tpl", { 
    eastip = azurerm_public_ip.gw-region-01.ip_address, 
    southip = azurerm_public_ip.gw-region-03.ip_address,   
    priv_ubuntu=azurerm_network_interface.platform-region-02.private_ip_address, 
    priv_network=cidrhost(azurerm_subnet.region-02-private01.address_prefixes[0],0),
    adminuser=var.adminuser,
    password=random_string.pass.result })):null
}

##region-03============
resource "azurerm_network_interface" "gw-region-03" {
  name                = "gw-region-03"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-03-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[2]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "gw-region-03-public" {
  name                = "gw-region-03-public"
  location            = azurerm_network_interface.gw-region-03.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.region-03-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[2]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.gw-region-03.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "gw-region-03" {
  name                    = "gw-region-03-public"
  location                = azurerm_network_interface.gw-region-03.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "gw-region-03" {
#   name                = "gw-region-03-public"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   security_rule {
#     name                         = "All"
#     protocol                     = "*"
#     source_port_ranges           = ["*"]
#     destination_port_ranges      = ["*"]
#     source_address_prefixes      = ["*"]
#     destination_address_prefixes = ["*"]
#     access                       = "Allow"
#     priority                     = 1020
#     direction                    = "Inbound"
#   }
# }
# resource "azurerm_network_interface_security_group_association" "gw-region-03" {
#   network_interface_id      = azurerm_network_interface.gw-region-03-public.id
#   network_security_group_id = azurerm_network_security_group.gw-region-03.id
# }


resource "azurerm_linux_virtual_machine" "gw-region-03" {
  name                = "gw-region-03"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_network_interface.gw-region-03.location
  plan {
    name      = "17_2_1-payg-sec"
    product   = "cisco-csr-1000v"
    publisher = "cisco"
  }
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "gw-region-03"
  network_interface_ids = [
    azurerm_network_interface.gw-region-03-public.id,
    azurerm_network_interface.gw-region-03.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "gw-region-03"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-gw-region-03.tpl", { eastip = azurerm_public_ip.gw-region-01.ip_address, westip = azurerm_public_ip.gw-region-02.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-gw-region-03.tpl", { 
    eastip = azurerm_public_ip.gw-region-01.ip_address, 
    westip = azurerm_public_ip.gw-region-02.ip_address,   
    priv_ubuntu=azurerm_network_interface.platform-region-03.private_ip_address, 
    priv_network=cidrhost(azurerm_subnet.region-03-private01.address_prefixes[0],0),
    adminuser=var.adminuser,
    password=random_string.pass.result })):null
}
