#SG for app alb
module "app_alb_sg" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.alb_instances[0]
  vpc_id      = local.vpc_id
}

# Allow connection from bastion to app alb
resource "aws_security_group_rule" "app_alb_bastion" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = local.protocol
  source_security_group_id = module.bastion.id
  security_group_id        = module.app_alb_sg.id
}

# Allow connection from frontend servers to app alb
resource "aws_security_group_rule" "app_alb_frontend" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = local.protocol
  source_security_group_id = module.frontend.id
  security_group_id        = module.app_alb_sg.id
}

# Allow connection from app alb to backend servers
resource "aws_security_group_rule" "backend_app_alb" {
  type                     = "ingress"
  from_port                = var.api_port
  to_port                  = var.api_port
  protocol                 = local.protocol
  source_security_group_id = module.app_alb_sg.id
  security_group_id        = module.backend.id
}