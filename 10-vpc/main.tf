module "vpc" {
  source = "git::https://github.com/MMahiketh/terraform-vpc-module.git?ref=master"

  project        = var.project
  environment    = var.environment
  vpc_cidr_block = var.vpc_cidr
  subnet_cidrs   = var.subnet_cidrs
}
