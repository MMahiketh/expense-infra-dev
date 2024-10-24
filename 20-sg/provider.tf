terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.10.0"
    }
  }
  backend "s3" {
    bucket         = "expense-dev-state-files"
    key            = "expense-infra-dev-sg"
    region         = "us-east-1"
    dynamodb_table = "expense-dev-locking"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
