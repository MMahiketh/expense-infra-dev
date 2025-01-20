# Amazon linux 2023 AMI
data "aws_ami" "az_linux" {
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Join devops practice AMI
data "aws_ami" "join_devops_ami" {
  owners      = ["973714476881"]
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Get security grouop ids
data "aws_ssm_parameter" "sg_id" {
  name = "${local.ssm_prefix}/${var.instance}/sg_id"
}

# Get public subnet id
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "${local.ssm_prefix}/public/subnet/ids"
}

#Get vpc id
data "aws_ssm_parameter" "vpc_id" {
  name = "${local.ssm_prefix}/vpc/id"
}

#Get web alb listerner arn
data "aws_ssm_parameter" "alb_listner_arn" {
  name = "${local.ssm_prefix}/web-alb-listner/arn"
}