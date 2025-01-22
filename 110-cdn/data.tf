data "aws_cloudfront_cache_policy" "noCache" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_cache_policy" "cacheOptmised" {
  name = "Managed-CachingOptimized"
}

data "aws_ssm_parameter" "https_certificate_arn" {
  name = "${local.ssm_prefix}/https_certificate/arn"
}