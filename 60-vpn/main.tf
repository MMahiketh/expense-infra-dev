module "vpn" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = local.ami_id
  name = "OpenVpn"

  key_name               = aws_key_pair.openvpn.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [local.vpn_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    { Name = "OpenVpn" },
    var.vpn_tags
  )
}

resource "aws_key_pair" "openvpn" {
  key_name   = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")
}