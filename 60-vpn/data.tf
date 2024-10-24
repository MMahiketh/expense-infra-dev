# Amazon linux 2023 AMI
data "aws_ami" "openvpn_ami" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Get security grouop ids
data "aws_ssm_parameter" "vpn_sg_id" {
  name = "${local.ssm_prefix}/${var.instance}/sg_id"
}

# Get public subnet id
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "${local.ssm_prefix}/public/subnet/ids"
}