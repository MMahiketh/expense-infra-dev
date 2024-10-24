resource "aws_ssm_parameter" "vpc_id" {
  name  = "${local.ssm_prefix}/vpc/id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "${local.ssm_prefix}/${local.network[0]}/subnet/ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "${local.ssm_prefix}/${local.network[1]}/subnet/ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "${local.ssm_prefix}/${local.network[2]}/subnet/ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "db_subnet_group_id" {
  name = "${local.ssm_prefix}/${local.network[2]}/subnet_group/id"
  type = "String"
  value = module.vpc.db_subnet_group_id
}