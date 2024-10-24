# Security groups for mysql, backend, frontend
module "mysql" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.instances[0]
  vpc_id      = local.vpc_id
}

module "backend" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.instances[1]
  vpc_id      = local.vpc_id
}

module "frontend" {
  source = "git::https://github.com/MMahiketh/terraform-sg-module.git?ref=master"

  project     = var.project
  environment = var.environment
  instance    = var.instances[2]
  vpc_id      = local.vpc_id
}

# Rules to allow connections for My App to work
resource "aws_security_group_rule" "mysql_backend" {
  type                     = "ingress"
  from_port                = var.mysql_port
  to_port                  = var.mysql_port
  protocol                 = local.protocol
  source_security_group_id = module.backend.id
  security_group_id        = module.mysql.id
}

resource "aws_security_group_rule" "backend_frontend" {
  type                     = "ingress"
  from_port                = var.api_port
  to_port                  = var.api_port
  protocol                 = local.protocol
  source_security_group_id = module.frontend.id
  security_group_id        = module.backend.id
}

resource "aws_security_group_rule" "frontend_internet" {
  type              = "ingress"
  from_port         = var.http_port
  to_port           = var.http_port
  protocol          = local.protocol
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.id
}