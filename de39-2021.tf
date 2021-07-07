module "competion" {
    source = "./terraform"
    count = 1
    prefix = format("comp-%02d", count.index+1)
}

output "passwords" {
  value = [ module.competion.*.pass ]
}