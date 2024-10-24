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

#listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>I'am application ALB</h1>"
      status_code  = 200
    }
  }
}

#Route 53 record for app alb ( *.app-dev.mahdo.site )
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.domain_name

  records = [
    {
      name = "*.app-${var.environment}" # *.app-dev.mahdo.site
      type = "A"
      alias = {
        name    = module.alb.dns_name
        zone_id = module.alb.zone_id
      }
      allow_overwrite = true
    }
  ]
}