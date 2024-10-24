locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  bastion_sg_id = data.aws_ssm_parameter.bastion_sg_id.value

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  ami_id = data.aws_ami.join_devops_ami.id

  public_subnet_id = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
}