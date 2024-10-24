locals {
  ssm_prefix = "/${var.project}/${var.environment}"
  network    = ["public", "private", "database"]
}