data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "${local.ssm_prefix}/public/subnet/ids"
}

data "aws_ssm_parameter" "web_alb_sg_id" {
  name = "${local.ssm_prefix}/${var.instance}/sg_id"
}

data "aws_ssm_parameter" "https_certificate_arn" {
  name = "${local.ssm_prefix}/https_certificate/arn"
}