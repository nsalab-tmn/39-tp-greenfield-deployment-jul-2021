output "pass" {
  value = {(azuread_user.competitor.user_principal_name) = random_string.pass.result}
}

# output "networks" {
#     value = {
#         "${var.prefix}-eastus-priv" = azurerm_subnet.eastus-private01.address_prefix,
#         "${var.prefix}-westus-priv" = azurerm_subnet.westus-private01.address_prefix,
#         "${var.prefix}-southcentralus-priv" = azurerm_subnet.southcentralus-private01.address_prefix,
       
#         "${var.prefix}-eastus-public" = azurerm_subnet.eastus-public01.address_prefix,
#         "${var.prefix}-westus-public" = azurerm_subnet.westus-public01.address_prefix,
#         "${var.prefix}-southcentralus-public" = azurerm_subnet.southcentralus-public01.address_prefix
#     }
# }
output "static-params" {
  value = {
    "region-01-private-network" = cidrhost(azurerm_subnet.eastus-private01.address_prefixes[0],0)
    "region-02-private-network" = cidrhost(azurerm_subnet.westus-private01.address_prefixes[0],0)
    "region-03-private-network" = cidrhost(azurerm_subnet.southcentralus-private01.address_prefixes[0],0)
    "platform-01-ip" = azurerm_network_interface.ubuntu-eastus.private_ip_address
    "platform-02-ip" = azurerm_network_interface.ubuntu-westus.private_ip_address
    "platform-03-ip" = azurerm_network_interface.ubuntu-southcentralus.private_ip_address
    "private-01-ip" = azurerm_network_interface.cisco-eastus.private_ip_address
    "private-02-ip" = azurerm_network_interface.cisco-westus.private_ip_address
    "private-03-ip" = azurerm_network_interface.cisco-southcentralus.private_ip_address
  }
}

output "dynamic-params" {
  value = {
    "${var.competition_instance}-${var.prefix}"= {
      "gw-01-public-ip" = azurerm_public_ip.cisco-eastus.ip_address
      "gw-02-public-ip" = azurerm_public_ip.cisco-westus.ip_address
      "gw-03-public-ip" = azurerm_public_ip.cisco-southcentralus.ip_address
      "adminuser" = var.adminuser
      "password" = random_string.pass.result
      "ad-username" = azuread_user.competitor.user_principal_name
      "prefix" = "${var.competition_instance}-${var.prefix}"
      "dns-zone" = azurerm_dns_zone.comp-hz.name

    }
  }
}



