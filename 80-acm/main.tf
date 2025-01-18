#Requesting SSL certificate
resource "aws_acm_certificate" "main" {
  domain_name       = "*.${local.zone_name}"
  validation_method = "DNS"

  tags = merge(
    local.common_tags,
    { Name = local.resource_name },
    var.acm_tags
  )
}

#Create r53 records for SSL
resource "aws_route53_record" "acm" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.zone_id
}

#Validate SSL certificate
resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.acm : record.fqdn]
}

#Parameters
resource "aws_ssm_parameter" "https_certificate_arn" {
  name  = "${local.ssm_prefix}/https_certificate/arn"
  type  = "String"
  value = aws_acm_certificate.main.arn
}