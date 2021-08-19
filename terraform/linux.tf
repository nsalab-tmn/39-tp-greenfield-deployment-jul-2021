##region-01============
resource "azurerm_network_interface" "platform-region-01" {
  name                = "platform-region-01"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-01-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[0]}.${var.subnet_octets[1]}.${var.host_octets[1]}"
  }
}

resource "azurerm_linux_virtual_machine" "platform-region-01" {
  depends_on                      = [azurerm_linux_virtual_machine.gw-region-01]
  name                            = "platform-region-01"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "platform-region-01"
  network_interface_ids = [
    azurerm_network_interface.platform-region-01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "platform-region-01"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-platform-region-01.tpl", {
    prefix="${var.competition_instance}-${var.prefix}",platform_01_ip=azurerm_network_interface.platform-region-01.private_ip_address,
    platform_02_ip=azurerm_network_interface.platform-region-02.private_ip_address,
    platform_03_ip=azurerm_network_interface.platform-region-03.private_ip_address})):null
}

##region-02============
resource "azurerm_network_interface" "platform-region-02" {
  name                = "platform-region-02"
  location            = "westcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-02-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[1]}.${var.subnet_octets[1]}.${var.host_octets[1]}"
  }
}

resource "azurerm_linux_virtual_machine" "platform-region-02" {
  depends_on                      = [azurerm_linux_virtual_machine.gw-region-02]
  name                            = "platform-region-02"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_network_interface.platform-region-02.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "platform-region-02"
  network_interface_ids = [
    azurerm_network_interface.platform-region-02.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "platform-region-02"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-platform-region-02.tpl", {
    prefix="${var.competition_instance}-${var.prefix}",platform_01_ip=azurerm_network_interface.platform-region-01.private_ip_address,
    platform_02_ip=azurerm_network_interface.platform-region-02.private_ip_address,
    platform_03_ip=azurerm_network_interface.platform-region-03.private_ip_address})):null
}

##region-03============
resource "azurerm_network_interface" "platform-region-03" {
  name                = "platform-region-03"
  location            = "southcentralus"
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.region-03-private01.id
    private_ip_address_allocation = "Static"
    private_ip_address_version    = "IPv4"
    primary                       = true
    private_ip_address            = "10.${var.region_octets[2]}.${var.subnet_octets[1]}.${var.host_octets[1]}"
  }
}


resource "azurerm_linux_virtual_machine" "platform-region-03" {
  depends_on                      = [azurerm_linux_virtual_machine.gw-region-03]
  name                            = "platform-region-03"
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_network_interface.platform-region-03.location
  size                            = "Standard_B2s"
  admin_username                  = var.adminuser
  admin_password                  = random_string.pass.result
  disable_password_authentication = false
  provision_vm_agent              = true


  allow_extension_operations = true
  computer_name              = "platform-region-03"
  network_interface_ids = [
    azurerm_network_interface.platform-region-03.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
    name                 = "platform-region-03"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  custom_data = var.deploy_custom_data ? base64encode(templatefile("${path.module}/${var.assets_path}/customdata-platform-region-03.tpl", {
    prefix="${var.competition_instance}-${var.prefix}",platform_01_ip=azurerm_network_interface.platform-region-01.private_ip_address,
    platform_02_ip=azurerm_network_interface.platform-region-02.private_ip_address,
    platform_03_ip=azurerm_network_interface.platform-region-03.private_ip_address})):null
}