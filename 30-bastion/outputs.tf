# output "al_ami_id" {
#   value = data.aws_ami.az_linux.id
# }

# output "ansible_public_ip" {
#   value = module.ansible.public_ip
# }

output "bastion_public_ip" {
  value = module.bastion.public_ip
}