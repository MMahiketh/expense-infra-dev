variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instances" {
  type    = list(string)
  default = ["ansible", "bastion"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# tags
variable "bastion_tags" {
  type    = map(any)
  default = {}
}

# variable "ansible_tags" {
#   type    = map(any)
#   default = {}
# }
