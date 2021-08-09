output "pass" {
  value = {(azuread_user.competitor.user_principal_name) = random_string.pass.result}
}

# output "networks" {
#     value = {
#         "${var.prefix}-region-01-priv" = azurerm_subnet.region-01-private01.address_prefix,
#         "${var.prefix}-region-02-priv" = azurerm_subnet.region-02-private01.address_prefix,
#         "${var.prefix}-region-03-priv" = azurerm_subnet.region-03-private01.address_prefix,
       
#         "${var.prefix}-region-01-public" = azurerm_subnet.region-01-public01.address_prefix,
#         "${var.prefix}-region-02-public" = azurerm_subnet.region-02-public01.address_prefix,
#         "${var.prefix}-region-03-public" = azurerm_subnet.region-03-public01.address_prefix
#     }
# }
output "static-params" {
  value = {
    "region-01-private-network" = cidrhost(azurerm_subnet.region-01-private01.address_prefixes[0],0)
    "region-02-private-network" = cidrhost(azurerm_subnet.region-02-private01.address_prefixes[0],0)
    "region-03-private-network" = cidrhost(azurerm_subnet.region-03-private01.address_prefixes[0],0)
    "platform-01-ip" = azurerm_network_interface.platform-region-01.private_ip_address
    "platform-02-ip" = azurerm_network_interface.platform-region-02.private_ip_address
    "platform-03-ip" = azurerm_network_interface.platform-region-03.private_ip_address
    "gw-01-private-ip" = azurerm_network_interface.gw-region-01.private_ip_address
    "gw-02-private-ip" = azurerm_network_interface.gw-region-02.private_ip_address
    "gw-03-private-ip" = azurerm_network_interface.gw-region-03.private_ip_address
  }
}

output "dynamic-params" {
  value = {
    "${var.competition_instance}-${var.prefix}"= {
      "gw-01-public-ip" = azurerm_public_ip.gw-region-01.ip_address
      "gw-02-public-ip" = azurerm_public_ip.gw-region-02.ip_address
      "gw-03-public-ip" = azurerm_public_ip.gw-region-03.ip_address
      "adminuser" = var.adminuser
      "password" = random_string.pass.result
      "ad-username" = azuread_user.competitor.user_principal_name
      "prefix" = "${var.competition_instance}-${var.prefix}"
      "dns-zone" = azurerm_dns_zone.comp-hz.name

    }
  }
}



