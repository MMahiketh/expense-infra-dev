data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}