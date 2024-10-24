variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instances" {
  type    = string
  default = "mysql"
}

variable "instance_type" {
  type    = string
  default = "db.t4g.micro"
}

# tags
variable "rds_tags" {
  type    = map(any)
  default = {}
}
