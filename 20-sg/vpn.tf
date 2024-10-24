#SG for bastion server
module "vpn" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.other_instances[2]
  vpc_id      = local.vpc_id
}

# Allow connection from vpn server to
## mysql
resource "aws_security_group_rule" "mysql_vpn" {
  type                     = "ingress"
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = local.protocol
  source_security_group_id = module.vpn.id
  security_group_id        = module.mysql.id
}

## backend
resource "aws_security_group_rule" "backend_vpn" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = local.protocol
  source_security_group_id = module.vpn.id
  security_group_id        = module.backend.id
}

## forntend
resource "aws_security_group_rule" "frontend_vpn" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = local.protocol
  source_security_group_id = module.vpn.id
  security_group_id        = module.frontend.id
}

## app alb
resource "aws_security_group_rule" "app_alb_vpn" {
  type                     = "ingress"
  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = local.protocol
  source_security_group_id = module.vpn.id
  security_group_id        = module.app_alb_sg.id
}


# Allow connection to vpn server form internet
## port 22
resource "aws_security_group_rule" "vpn_internet_22" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.id
}

## port 443
resource "aws_security_group_rule" "vpn_internet_443" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.id
}

## port 943
resource "aws_security_group_rule" "vpn_internet_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.id
}

## port 1194
resource "aws_security_group_rule" "vpn_internet_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.vpn.id
}