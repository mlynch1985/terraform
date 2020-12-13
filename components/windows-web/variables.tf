variable "default_tags" {}

locals {
  namespace   = var.default_tags["namespace"]
  environment = var.default_tags["environment"]

  component     = "windows-web"
  instance_type = "t3.large"
  asg_min       = 3
  asg_max       = 3
  asg_desired   = 3

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

data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}
