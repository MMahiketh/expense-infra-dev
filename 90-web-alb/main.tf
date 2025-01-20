module "alb" {
  source = "terraform-aws-modules/alb/aws"

  name    = "${local.resource_name}-${var.instance}"
  vpc_id  = local.vpc_id
  subnets = local.public_subnet_ids

  # Security Group
  create_security_group = false
  security_groups       = [local.web_alb_sg_id]

  internal                   = false
  enable_deletion_protection = false

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
      message_body = "<h1>I'am web tier ALB from HTTP</h1>"
      status_code  = 200
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.https_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>I'am web tier ALB from HTTPS</h1>"
      status_code  = 200
    }
  }
}

#Route 53 record for web alb ( expense-dev.mahdo.site )
module "records" {
  source = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = var.zone_name

  records = [
    {
      name = "${local.resource_name}"     # expense-dev.mahdo.site
      type = "A"
      alias = {
        name    = module.alb.dns_name
        zone_id = module.alb.zone_id
      }
      allow_overwrite = true
    }
  ]
}

#Parameter
resource "aws_ssm_parameter" "alb_listner_arn" {
  name  = "${local.ssm_prefix}/${var.instance}-listner/arn"
  type  = "String"
  value = aws_lb_listener.https.arn
}