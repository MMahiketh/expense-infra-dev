data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = "${local.ssm_prefix}/private/subnet/ids"
}

data "aws_ssm_parameter" "app_alb_sg_id" {
  name = "${local.ssm_prefix}/${var.instance}/sg_id"
}