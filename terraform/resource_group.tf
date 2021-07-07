variable "prefix" {
  default = "comp-99"
}

variable "adminuser" {
  default = "azadmin"
}
# variable "adminpass" {
#   default = "4eEAV4_H!M^a"
# }

variable "prod_rg" {
  default = "nsalab-prod"
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.prefix}"
  location = "eastus"
}

resource "random_string" "pass" {
  length           = 16
  special          = false
  min_lower        = 2
  min_numeric      = 2
  min_upper        = 2
  min_special      = 1
  override_special = "+-=%#^@"
}

resource "azuread_user" "competitor" {
  user_principal_name = "${var.prefix}@nsalab.org"
  display_name        = var.prefix
  mail_nickname       = var.prefix
  password            = random_string.pass.result
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_user.competitor.object_id
}

output "pass" {
  value = {(var.prefix) = random_string.pass.result}
}
