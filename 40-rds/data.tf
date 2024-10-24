# Get security group id
data "aws_ssm_parameter" "mysql_sg_id" {
  name = "${local.ssm_prefix}/${var.instance}/sg_id"
}

# Get database subnet group id
data "aws_ssm_parameter" "db_subnet_group_id" {
  name = "${local.ssm_prefix}/database/subnet_group/id"
}