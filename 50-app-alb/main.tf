module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${local.resource_name}-${var.instance}"
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids

  # Security Group
  create_security_group = false
  security_groups       = [local.app_alb_sg_id]

  internal = true

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}-${var.instance}" },
    var.alb_tags
  )
}