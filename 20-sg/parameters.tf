# Store security group ids in parameter store
resource "aws_ssm_parameter" "mysql_sg_id" {
  name  = "${local.ssm_prefix}/${var.instances[0]}/sg_id"
  type  = "String"
  value = module.mysql.id
}

resource "aws_ssm_parameter" "backend_sg_id" {
  name  = "${local.ssm_prefix}/${var.instances[1]}/sg_id"
  type  = "String"
  value = module.backend.id
}

resource "aws_ssm_parameter" "frontend_sg_id" {
  name  = "${local.ssm_prefix}/${var.instances[2]}/sg_id"
  type  = "String"
  value = module.frontend.id
}

# resource "aws_ssm_parameter" "ansible_sg_id" {
#   name  = "${local.ssm_prefix}/${var.other_instances[0]}/sg_id"
#   type  = "String"
#   value = module.ansible.id
# }

resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "${local.ssm_prefix}/${var.other_instances[1]}/sg_id"
  type  = "String"
  value = module.bastion.id
}

resource "aws_ssm_parameter" "app_alb_sg_id" {
  name  = "${local.ssm_prefix}/${var.alb_instances[0]}/sg_id"
  type  = "String"
  value = module.app_alb_sg.id
}

resource "aws_ssm_parameter" "vpn_sg_id" {
  name  = "${local.ssm_prefix}/${var.other_instances[2]}/sg_id"
  type  = "String"
  value = module.vpn.id
}