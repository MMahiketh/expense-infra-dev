locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  zone_id   = "Z02855522FE67JKRUDSDP"
  zone_name = "mahdo.site"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
