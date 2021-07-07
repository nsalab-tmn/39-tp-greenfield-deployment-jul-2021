resource "azurerm_dns_zone" "comp-hz" {
  name                = "${var.prefix}.az.skillscloud.company"
  resource_group_name = azurerm_resource_group.main.name
}



resource "azurerm_dns_ns_record" "parrent_record" {
  name                = var.prefix
  zone_name           = "az.skillscloud.company"
  resource_group_name = var.prod_rg
  ttl                 = 300

  records = azurerm_dns_zone.comp-hz.name_servers
}

