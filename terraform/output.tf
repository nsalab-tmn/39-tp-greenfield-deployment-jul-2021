output "pass" {
  value = {(azuread_user.competitor.user_principal_name) = random_string.pass.result}
}

output "networks" {
    value = {
        "${var.prefix}-eastus-priv" = azurerm_subnet.eastus-private01.address_prefix,
        "${var.prefix}-westus-priv" = azurerm_subnet.westus-private01.address_prefix,
        "${var.prefix}-southcentralus-priv" = azurerm_subnet.southcentralus-private01.address_prefix,
       
        "${var.prefix}-eastus-public" = azurerm_subnet.eastus-public01.address_prefix,
        "${var.prefix}-westus-public" = azurerm_subnet.westus-public01.address_prefix,
        "${var.prefix}-southcentralus-public" = azurerm_subnet.southcentralus-public01.address_prefix
    }
}