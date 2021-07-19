module "competion" {
    source = "./terraform"
    count = 1
    prefix = format("comp-%02d", count.index+1)
    deploy_routes = false
    deploy_dns_a_records = false
    deploy_custom_data = false
    competition_instance = "gfd-39"
}

output "passwords" {
  value =  module.competion.*.pass 
}

output "networks" {
  value =  module.competion.*.networks 
}