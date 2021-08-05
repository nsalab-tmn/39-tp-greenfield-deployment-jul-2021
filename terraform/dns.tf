resource "azurerm_dns_zone" "comp-hz" {
  name                = "${var.competition_instance}-${var.prefix}.az.skillscloud.company"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_dns_ns_record" "parrent_record" {
  name                = "${var.competition_instance}-${var.prefix}"
  zone_name           = "az.skillscloud.company"
  resource_group_name = var.prod_rg
  ttl                 = 300

  records = azurerm_dns_zone.comp-hz.name_servers
}

resource "azurerm_dns_a_record" "eastus" {
  count = var.deploy_dns_a_records ? 1 : 0
  name                = "eastus"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.gw-region-01.ip_address]
}

resource "azurerm_dns_a_record" "westus" {
  count = var.deploy_dns_a_records ? 1 : 0
  name                = "westus"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.gw-region-02.ip_address]
}

resource "azurerm_dns_a_record" "southcentralus" {
  count = var.deploy_dns_a_records ? 1 : 0
  name                = "southcentralus"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.gw-region-03.ip_address]
}

resource "azurerm_dns_a_record" "app" {
  count = var.deploy_dns_a_records ? 1 : 0
  name                = "app"
  zone_name           = azurerm_dns_zone.comp-hz.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  records             = [azurerm_public_ip.gw-region-01.ip_address,azurerm_public_ip.gw-region-02.ip_address, azurerm_public_ip.gw-region-03.ip_address]
}
