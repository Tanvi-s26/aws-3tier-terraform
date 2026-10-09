output "alb_url" {
  value = "http://${module.compute.alb_dns_name}"
}