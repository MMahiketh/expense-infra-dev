locals {
  resource_name = "${var.project}-${var.environment}"
  ssm_prefix    = "/${var.project}/${var.environment}"

  ami_id          = data.aws_ami.join_devops_ami.id
  vpc_id          = data.aws_ssm_parameter.vpc_id.value
  sg_id           = data.aws_ssm_parameter.sg_id.value
  subnet_ids      = split(",", data.aws_ssm_parameter.private_subnet_ids.value)
  alb_listner_arn = data.aws_ssm_parameter.alb_listner_arn.value


  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }
}
