#Create cloudfront distribution
resource "aws_cloudfront_distribution" "main" {
  origin {
    domain_name = "${local.resource_name}.${local.zone_name}"
    origin_id   = "${local.resource_name}.${local.zone_name}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled = true
  aliases = ["${var.project}-cdn.${local.zone_name}"]

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "${local.resource_name}.${local.zone_name}"
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 1000
    max_ttl                = 86400
    cache_policy_id        = data.aws_cloudfront_cache_policy.noCache.id
  }

  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "${local.resource_name}.${local.zone_name}"

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = data.aws_cloudfront_cache_policy.cacheOptmised.id
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "CA", "GB", "DE"]

    }
  }

  viewer_certificate {
    acm_certificate_arn      = local.https_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.resource_name}" },
    var.cdn_tags
  )
}

#Create r53 records for SSL
module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"

  zone_name = local.zone_name 
  records = [
    {
      name    = "${var.project}-cdn" 
      type    = "A"
      alias   = {
        name    = aws_cloudfront_distribution.main.domain_name
        zone_id = aws_cloudfront_distribution.main.hosted_zone_id # This belongs CDN internal hosted zone, not ours
      }
      allow_overwrite = true
    }
  ]
}
