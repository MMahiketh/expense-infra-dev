#SG for web alb
module "web_alb_sg" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.alb_instances[1]
  vpc_id      = local.vpc_id
}

# Accept connection from
## bastion to web alb
resource "aws_security_group_rule" "web_alb_bastion" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = local.protocol
  source_security_group_id = module.bastion.id
  security_group_id        = module.web_alb_sg.id
}

## http to web alb
resource "aws_security_group_rule" "web_alb_http" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.id
}

## https to web alb
resource "aws_security_group_rule" "web_alb_https" {
  type              = "ingress"
  from_port         = var.https_port
  to_port           = var.https_port
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.web_alb_sg.id
}

## web alb to frontend servers
resource "aws_security_group_rule" "frontend_web_alb" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = local.protocol
  source_security_group_id = module.web_alb_sg.id
  security_group_id        = module.frontend.id
}