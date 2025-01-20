output "frontend_private_ip" {
  value = module.main.private_ip
}

output "ami_id_frontend" {
  value = aws_ami_from_instance.main.id
}