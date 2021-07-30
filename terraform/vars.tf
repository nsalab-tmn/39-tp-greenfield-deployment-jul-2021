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

variable "region_octets" {
  default = ["1", "2", "3"]
}

variable "subnet_octets" {
  default = ["1", "10", "99"]
}

variable "host_octets" {
  default = ["4", "6"]
}
