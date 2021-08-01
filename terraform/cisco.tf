##EASTUS============
resource "azurerm_network_interface" "cisco-eastus" {
  name                = "${var.prefix}-cisco-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.eastus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[0]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "cisco-eastus-public" {
  name                = "${var.prefix}-cisco-eastus-public"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.eastus-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[0]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.cisco-eastus.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "cisco-eastus" {
  name                    = "${var.prefix}-cisco-eastus-public"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "cisco-eastus" {
#   name                = "${var.prefix}-cisco-eastus-public"
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
# resource "azurerm_network_interface_security_group_association" "cisco-eastus" {
#   network_interface_id      = azurerm_network_interface.cisco-eastus-public.id
#   network_security_group_id = azurerm_network_security_group.cisco-eastus.id
# }


resource "azurerm_linux_virtual_machine" "cisco-eastus" {
  name                = "${var.prefix}-cisco-eastus"
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
  computer_name              = "${var.prefix}-cisco-eastus"
  network_interface_ids = [
    azurerm_network_interface.cisco-eastus-public.id,
    azurerm_network_interface.cisco-eastus.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "${var.prefix}-cisco-eastus"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-cisco-eastus.tpl", { westip = azurerm_public_ip.cisco-westus.ip_address, southip = azurerm_public_ip.cisco-southcentralus.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-cisco-eastus.tpl", { westip = azurerm_public_ip.cisco-westus.ip_address, southip = azurerm_public_ip.cisco-southcentralus.ip_address,
  priv_ubuntu=azurerm_network_interface.ubuntu-eastus.private_ip_address, priv_network=cidrhost(azurerm_subnet.eastus-private01.address_prefixes[0],0) })):null
}
##WESTUS============
resource "azurerm_network_interface" "cisco-westus" {
  name                = "${var.prefix}-cisco-westus"
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.westus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[1]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "cisco-westus-public" {
  name                = "${var.prefix}-cisco-westus-public"
  location            = azurerm_network_interface.cisco-westus.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.westus-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[1]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.cisco-westus.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "cisco-westus" {
  name                    = "${var.prefix}-cisco-westus-public"
  location                = azurerm_network_interface.cisco-westus.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "cisco-westus" {
#   name                = "${var.prefix}-cisco-westus-public"
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
# resource "azurerm_network_interface_security_group_association" "cisco-westus" {
#   network_interface_id      = azurerm_network_interface.cisco-westus-public.id
#   network_security_group_id = azurerm_network_security_group.cisco-westus.id
# }


resource "azurerm_linux_virtual_machine" "cisco-westus" {
  name                = "${var.prefix}-cisco-westus"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_network_interface.cisco-westus.location
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
  computer_name              = "${var.prefix}-cisco-westus"
  network_interface_ids = [
    azurerm_network_interface.cisco-westus-public.id,
    azurerm_network_interface.cisco-westus.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "${var.prefix}-cisco-westus"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-cisco-westus.tpl", { eastip = azurerm_public_ip.cisco-eastus.ip_address, southip = azurerm_public_ip.cisco-southcentralus.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-cisco-westus.tpl", { eastip = azurerm_public_ip.cisco-eastus.ip_address, southip = azurerm_public_ip.cisco-southcentralus.ip_address,   priv_ubuntu=azurerm_network_interface.ubuntu-westus.private_ip_address, priv_network=cidrhost(azurerm_subnet.westus-private01.address_prefixes[0],0) })):null
}

##SOUTHCENTRALUS============
resource "azurerm_network_interface" "cisco-southcentralus" {
  name                = "${var.prefix}-cisco-southcentralus"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.southcentralus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[2]}.${var.subnet_octets[1]}.${var.host_octets[0]}"
  }
  enable_ip_forwarding = true
}

resource "azurerm_network_interface" "cisco-southcentralus-public" {
  name                = "${var.prefix}-cisco-southcentralus-public"
  location            = azurerm_network_interface.cisco-southcentralus.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.southcentralus-public01.id
    private_ip_address_allocation = "Static" #have to be Dynamic according to template. why?
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[2]}.${var.subnet_octets[0]}.${var.host_octets[0]}"
    public_ip_address_id          = azurerm_public_ip.cisco-southcentralus.id
  }
  enable_ip_forwarding = true
}

resource "azurerm_public_ip" "cisco-southcentralus" {
  name                    = "${var.prefix}-cisco-southcentralus-public"
  location                = azurerm_network_interface.cisco-southcentralus.location
  resource_group_name     = azurerm_resource_group.main.name
  sku                     = "Basic"
  allocation_method       = "Static"
  ip_version              = "IPv4"
  idle_timeout_in_minutes = 4
}

# resource "azurerm_network_security_group" "cisco-southcentralus" {
#   name                = "${var.prefix}-cisco-southcentralus-public"
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
# resource "azurerm_network_interface_security_group_association" "cisco-southcentralus" {
#   network_interface_id      = azurerm_network_interface.cisco-southcentralus-public.id
#   network_security_group_id = azurerm_network_security_group.cisco-southcentralus.id
# }


resource "azurerm_linux_virtual_machine" "cisco-southcentralus" {
  name                = "${var.prefix}-cisco-southcentralus"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_network_interface.cisco-southcentralus.location
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
  computer_name              = "${var.prefix}-cisco-southcentralus"
  network_interface_ids = [
    azurerm_network_interface.cisco-southcentralus-public.id,
    azurerm_network_interface.cisco-southcentralus.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 16
    name                 = "${var.prefix}-cisco-southcentralus"
  }

  source_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "17_2_1-payg-sec"
    version   = "latest"
  }
  #custom_data = base64encode(templatefile("${path.module}/customdata-cisco-southcentralus.tpl", { eastip = azurerm_public_ip.cisco-eastus.ip_address, westip = azurerm_public_ip.cisco-westus.ip_address }))
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-cisco-southcentralus.tpl", { eastip = azurerm_public_ip.cisco-eastus.ip_address, westip = azurerm_public_ip.cisco-westus.ip_address,   priv_ubuntu=azurerm_network_interface.ubuntu-southcentralus.private_ip_address, priv_network=cidrhost(azurerm_subnet.southcentralus-private01.address_prefixes[0],0) })):null
}
