variable "prefix" {
  default = "comp-99"
  type = string
}

variable "competition_instance" {
  default = "gfd39"
  type = string
}
variable "adminuser" {
  default = "azadmin"
  type = string
}

# variable "adminpass" {
#   default = "4eEAV4_H!M^a"
# }

variable "prod_rg" {
  default = "nsalab-prod"
  type = string
}

variable "deploy_custom_data" {
  default = false
  type = bool
}

variable "deploy_routes" {
  default = false
  type = bool
}

variable "deploy_dns_a_records" {
  default = false
  type = bool
}

variable "assets_path" {
  type = string
  default = "assets"
  validation {
    condition     = (var.assets_path == "assets" ||  
      var.assets_path == "assets-tshoot") 
    error_message = "The assets_path variable must be equal to `assets` or `assets-tshoot`."
  }
  description = "The assets path for custom data. It works only if deploy_custom_data variable is set."
}

variable "region-01_default_route" {
  default = true
  type = bool
  description = "Set this variable only when finished custom_data deployment"

}

variable "region_octets" {
  type    = list(string)
  default = ["1", "2", "3"]
  validation {
    condition     = (length(var.region_octets) == 3 && 
      tonumber(var.region_octets[0]) > 0 && tonumber(var.region_octets[0]) < 255 &&
      tonumber(var.region_octets[1]) > 0 && tonumber(var.region_octets[1]) < 255 &&
      tonumber(var.region_octets[2]) > 0 && tonumber(var.region_octets[2]) < 255 &&
      tonumber(var.region_octets[0]) != tonumber(var.region_octets[1]) &&
      tonumber(var.region_octets[0]) != tonumber(var.region_octets[2]) &&
      tonumber(var.region_octets[1]) != tonumber(var.region_octets[2])       
      ) 
    error_message = "The region_octets  list must have 3 different items 0<item<255."
  }
}

variable "subnet_octets" {
  type    = list(string)
  default = ["1", "10", "99"]
    validation {
    condition     = (length(var.subnet_octets) == 3 && 
      tonumber(var.subnet_octets[0]) > 0 && tonumber(var.subnet_octets[0]) < 255 &&
      tonumber(var.subnet_octets[1]) > 0 && tonumber(var.subnet_octets[1]) < 255 &&
      tonumber(var.subnet_octets[2]) > 0 && tonumber(var.subnet_octets[2]) < 255 &&
      tonumber(var.subnet_octets[0]) != tonumber(var.subnet_octets[1]) &&
      tonumber(var.subnet_octets[0]) != tonumber(var.subnet_octets[2]) &&
      tonumber(var.subnet_octets[1]) != tonumber(var.subnet_octets[2])       
      ) 
    error_message = "The subnet_octets  list must have 3 different items 0<item<255."
  }
}

variable "host_octets" {
  type    = list(string)
  default = ["4", "6"]
  validation {
    condition     = (length(var.host_octets) == 2 && 
      tonumber(var.host_octets[0]) > 0 && tonumber(var.host_octets[0]) < 255 &&
      tonumber(var.host_octets[1]) > 0 && tonumber(var.host_octets[1]) < 255 &&
      tonumber(var.host_octets[0]) != tonumber(var.host_octets[1])      
      ) 
    error_message = "The host_octets  list must have 2 different items 0<item<255."
  }
}
