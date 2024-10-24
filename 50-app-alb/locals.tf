locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  vpc_id             = data.aws_ssm_parameter.vpc_id.value
  private_subnet_ids = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  app_alb_sg_id      = data.aws_ssm_parameter.app_alb_sg_id.value

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}