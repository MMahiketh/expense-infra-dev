variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = list(list(string))
  default = [
    ["10.0.1.0/24", "10.0.11.0/24", "10.0.21.0/24"],
    ["10.0.2.0/24", "10.0.12.0/24", "10.0.22.0/24"]
  ]
}