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

data "aws_region" "current" {}

variable "subnet_id" {
  description = "Subnet ID to launch the instances in"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to create a security group in"
  type        = string
}
