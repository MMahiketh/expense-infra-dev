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
  default = "frontend"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "mysql_pass" {
  type    = string
  default = "ExpenseApp1"
}

variable "domain" {
  type    = string
  default = "mahdo.site"
}

# tags
variable "frontend_tags" {
  type    = map(any)
  default = {}
}

