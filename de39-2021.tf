resource "random_string" "seed" {
  count = 3
  length           = 16
  special          = false
  min_lower        = 2
  min_numeric      = 2
  min_upper        = 2
  min_special      = 1
  override_special = "+-=%#^@"

}

resource "random_shuffle" "region_octet" {
  input        = range(2, 254)
  keepers = {
    # Generate a new id each time we switch to a new network seedid
    seed_id = random_string.seed[0].id
  }
  result_count = 3
  seed = random_string.seed[0].result
}

resource "random_shuffle" "subnet_octet" {
  input        = range(1, 254)
  keepers = {
    # Generate a new id each time we switch to a new network seedid
    seed_id = random_string.seed[1].id
  }
  result_count = 3
  seed = random_string.seed[1].result
}

resource "random_shuffle" "host_octet" {
  input        = range(1, 254)
  keepers = {
    # Generate a new id each time we switch to a new network seedid
    seed_id = random_string.seed[2].id
  }
  result_count = 2
  seed = random_string.seed[2].result
}

variable prefix {
  default = "comp-"
}
variable competition_instance {
  default = "gfd-39"
}

variable competition_count {
  default = 13
}

variable "deploy_custom_data" {
  default = true
  type = bool
}

variable "deploy_routes" {
  default = true
  type = bool
}

variable "deploy_dns_a_records" {
  default = true
  type = bool
}

variable "assets_path" {
  type = string
  default = "assets-tshoot"
  validation {
    condition     = (var.assets_path == "assets" ||  
      var.assets_path == "assets-tshoot") 
    error_message = "The assets_path variable must be equal to `assets` or `assets-tshoot`."
  }
  description = "The assets path for custom data. It works only if deploy_custom_data variable is set."
}

variable "eastus_default_route" {
  default = false
  type = bool
  description = "Set this variable only when finished custom_data deployment"

}


module "competition" {
    source = "./terraform"
    count = var.competition_count
    prefix = format("${var.prefix}%02d", count.index+1)
    deploy_routes = var.deploy_routes
    deploy_dns_a_records = var.deploy_dns_a_records
    deploy_custom_data = var.deploy_custom_data
    assets_path = var.assets_path
    region-01_default_route = var.eastus_default_route
    competition_instance = var.competition_instance
    region_octets = random_shuffle.region_octet.result
    subnet_octets = random_shuffle.subnet_octet.result
    host_octets = random_shuffle.host_octet.result
}

output "seeds" {
  value = random_string.seed.*.result
}

output "passwords" {
  value =  module.competition.*.pass 
}

output "static-params" {
  value =  module.competition[0].static-params 
}

output "dynamic-params" {
  value = merge(module.competition.*.dynamic-params...)
}
