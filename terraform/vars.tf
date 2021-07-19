variable "prefix" {
  default = "comp-99"
}

variable "competition_instance" {
  default = "gfd39-21-07"
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

variable "deploy_custom_data" {
  default = false
}

variable "deploy_routes" {
  default = false
}

variable "deploy_dns_a_records" {
  default = false
}