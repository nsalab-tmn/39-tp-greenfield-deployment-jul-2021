##EASTUS============
resource "azurerm_network_interface" "ubuntu-eastus" {
  name                = "${var.prefix}-ubuntu-eastus"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.eastus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.1.10.6"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu-eastus" {
  depends_on                      = [azurerm_linux_virtual_machine.cisco-eastus]
  name                            = "${var.prefix}-ubuntu-eastus"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "${var.prefix}-ubuntu-eastus"
  network_interface_ids = [
    azurerm_network_interface.ubuntu-eastus.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "${var.prefix}-ubuntu-eastus"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/assets/customdata-ubuntu.tpl", {})):null
}

##WESTUS============
resource "azurerm_network_interface" "ubuntu-westus" {
  name                = "${var.prefix}-ubuntu-westus"
  location            = "westus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.westus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.2.10.6"
  }
}

resource "azurerm_linux_virtual_machine" "ubuntu-westus" {
  depends_on                      = [azurerm_linux_virtual_machine.cisco-westus]
  name                            = "${var.prefix}-ubuntu-westus"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_network_interface.ubuntu-westus.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "${var.prefix}-ubuntu-westus"
  network_interface_ids = [
    azurerm_network_interface.ubuntu-westus.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "${var.prefix}-ubuntu-westus"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
   custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/assets/customdata-ubuntu.tpl",{})):null
  
}

##SOUTHCENTRALUS============
resource "azurerm_network_interface" "ubuntu-southcentralus" {
  name                = "${var.prefix}-ubuntu-southcentralus"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.southcentralus-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.3.10.6"
  }
}


resource "azurerm_linux_virtual_machine" "ubuntu-southcentralus" {
  depends_on                      = [azurerm_linux_virtual_machine.cisco-southcentralus]
  name                            = "${var.prefix}-ubuntu-southcentralus"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_network_interface.ubuntu-southcentralus.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "${var.prefix}-ubuntu-southcentralus"
  network_interface_ids = [
    azurerm_network_interface.ubuntu-southcentralus.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "${var.prefix}-ubuntu-southcentralus"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
   custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/assets/customdata-ubuntu.tpl", {})):null
}