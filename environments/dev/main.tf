module "vpc" {
  source = "../../modules/vpc"

  name               = "ha3tier-dev"
  enable_nat_gateway = true
}