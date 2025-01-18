variable "project" {
  type    = string
  default = "expense"
}

variable "environment" {
  type    = string
  default = "dev"
}

# tags
variable "acm_tags" {
  type    = map(any)
  default = {}
}

