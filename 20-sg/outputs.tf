output "mysql_sg_id" {
  value = module.mysql.id
}

output "backend_sg_id" {
  value = module.backend.id
}

output "frontend_sg_id" {
  value = module.frontend.id
}

output "bastion_sg_id" {
  value = module.bastion.id
}

output "app_alb_sg_id" {
  value = module.app_alb_sg.id
}