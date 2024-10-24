locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  mysql_sg_id = data.aws_ssm_parameter.mysql_sg_id.value
  db_subnet_group_name = data.aws_ssm_parameter.db_subnet_group_id.value

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}