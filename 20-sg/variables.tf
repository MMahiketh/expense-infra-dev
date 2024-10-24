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
  default = ["mysql", "backend", "frontend"]
}

variable "other_instances" {
  type    = list(string)
  default = ["ansible", "bastion"]
}

variable "alb_instances" {
  type    = list(string)
  default = ["app-alb"]
}

# Ports
variable "mysql_port" {
  type    = number
  default = 3306
}

variable "api_port" {
  type    = number
  default = 8080
}

variable "http_port" {
  type    = number
  default = 80
}

variable "ssh_port" {
  type    = number
  default = 22
}