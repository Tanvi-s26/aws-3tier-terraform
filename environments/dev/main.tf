module "vpc" {
  source = "../../modules/vpc"

  name               = "ha3tier-dev"
  enable_nat_gateway = true
}
module "compute" {
  source = "../../modules/compute"

  name               = "ha3tier-dev"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  alb_sg_id          = module.vpc.alb_sg_id
  app_sg_id          = module.vpc.app_sg_id
}

module "database" {
  source = "../../modules/database"

  name                = "ha3tier-dev"
  database_subnet_ids = module.vpc.database_subnet_ids
  db_sg_id            = module.vpc.db_sg_id
}