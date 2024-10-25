# Amazon linux 2023 AMI
data "aws_ami" "ubuntu_ami" {
  owners      = ["099720109477"]
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04*"]
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