output "backend_private_ip" {
  value = module.main.private_ip
}

output "ami_id_backend" {
  value = aws_ami_from_instance.main.id
}