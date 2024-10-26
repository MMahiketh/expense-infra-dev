variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance" {
  type    = string
  default = "backend"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# tags
variable "backend_tags" {
  type    = map(any)
  default = {}
}

