provider "aws" {
  region = "us-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
  backend "s3" {
    bucket         = "gsuite-automation-terraform-remote-state"
    region         = "us-west-2"
    key            = "gsuite/terraform.tfstate"
    dynamodb_table = "gsuite-automation-terraform-lock-state"
    encrypt        = true
  }
}

data "aws_caller_identity" "current" {}