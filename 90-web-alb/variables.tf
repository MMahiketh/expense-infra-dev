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
  default = "web-alb"
}

#Domain name for route 53 records
variable "zone_name" {
  type    = string
  default = "mahdo.site"
}

#tags
variable "alb_tags" {
  type    = map(any)
  default = {}
}