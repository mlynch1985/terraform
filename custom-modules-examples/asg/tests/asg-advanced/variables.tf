data "aws_caller_identity" "current" {}

data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_subnets" "tester" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

variable "vpc_id" {
  description = "Please specify a VPC ID"
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-zA-Z]{17}$", var.vpc_id))
    error_message = "Please specify a valid VPC ID (^vpc-[0-9a-zA-Z]{17}$)"
  }
}

variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}
