module "bastion" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = local.ami_id
  name = "${local.resource_name}-${var.instances[1]}"

  instance_type          = var.instance_type
  vpc_security_group_ids = [local.bastion_sg_id]
  subnet_id              = local.public_subnet_id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instances[1]}" },
    var.bastion_tags
  )
}

# module "ansible" {
#   source = "terraform-aws-modules/ec2-instance/aws"

#   ami  = local.ami_id
#   name = "${local.resource_name}-${var.instances[0]}"

#   instance_type          = var.instance_type
#   vpc_security_group_ids = [local.sg_ids.ansible]
#   subnet_id              = local.public_subnet_id
#   user_data              = file("ansible-setup.sh")

#   tags = merge(
#     local.common_tags,
#     { Name = "${local.resource_name}-${var.instances[0]}" },
#     var.ansible_tags
#   )
# }