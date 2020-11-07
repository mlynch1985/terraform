variable "namespace" {}
variable "name" {}
variable "region" {}
variable "lob" {}
variable "team" {}
variable "environment" {}

locals {
  default_tags = {
    namespace : var.namespace,
    name : var.name,
    lob : var.lob,
    team : var.team,
    environment : var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "this" {
  tags = {
    Name = "${var.namespace}_vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    tier = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    tier = "private"
  }
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
