#SG for bastion server
module "bastion" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.other_instances[1]
  vpc_id      = local.vpc_id
}

# Allow connection from bastion server to servers
resource "aws_security_group_rule" "mysql_bastion" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = local.protocol
  source_security_group_id = module.bastion.id
  security_group_id        = module.mysql.id
}

resource "aws_security_group_rule" "backend_bastion" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = local.protocol
  source_security_group_id = module.bastion.id
  security_group_id        = module.backend.id
}

resource "aws_security_group_rule" "frontend_bastion" {
  type                     = "ingress"
  from_port                = var.ssh_port
  to_port                  = var.ssh_port
  protocol                 = local.protocol
  source_security_group_id = module.bastion.id
  security_group_id        = module.frontend.id
}

# Allow connection from internet to bastion
resource "aws_security_group_rule" "bastion_internet" {
  type              = "ingress"
  from_port         = var.ssh_port
  to_port           = var.ssh_port
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.id
}