output "alb_url" {
  value = "http://${module.compute.alb_dns_name}"
}

output "db_identifier" {
  value = module.database.db_identifier
}