variable "default_tags" {}

locals {
  namespace   = var.default_tags["namespace"]
  environment = var.default_tags["environment"]

  component        = "wordpress"
  instance_type    = "c5.large"
  min_size         = 3
  max_size         = 3
  desired_capacity = 3

  default_tags = merge(
    var.default_tags,
    map(
      "component", local.component
    )
  )
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "this" {
  tags = {
    Name = "${local.namespace}_vpc"
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

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}