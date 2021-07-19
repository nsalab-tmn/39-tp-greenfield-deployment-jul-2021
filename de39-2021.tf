module "competion" {
    source = "./terraform"
    count = 1
    prefix = format("comp-%02d", count.index+1)
    deploy_routes = true
    deploy_dns_a_records = true
    deploy_custom_data = true
}

output "passwords" {
  value =  module.competion.*.pass 
}

output "networks" {
  value =  module.competion.*.networks 
}