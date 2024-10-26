module "main" {
  source = "terraform-aws-modules/ec2-instance/aws"

  ami  = local.ami_id
  name = "${local.resource_name}-${var.instance}"

  instance_type          = var.instance_type
  vpc_security_group_ids = [local.sg_id]
  subnet_id              = local.subnet_id

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instance}" },
    var.backend_tags
  )
}
