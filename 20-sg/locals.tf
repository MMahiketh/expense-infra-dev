locals {
  ssm_prefix = "/${var.project}/${var.environment}"
  vpc_id     = data.aws_ssm_parameter.vpc_id.value
  protocol   = "tcp"
}