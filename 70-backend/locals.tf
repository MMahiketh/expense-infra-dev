locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  ami_id = data.aws_ami.join_devops_ami.id
  sg_id = data.aws_ssm_parameter.sg_id.value
  subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}