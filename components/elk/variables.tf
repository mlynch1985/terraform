variable "vpc_id" {}
variable "default_tags" {}

locals {
  namespace   = var.default_tags["namespace"]
  environment = var.default_tags["environment"]

  component     = "elk"
  instance_type = "c5.large"

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
  id = var.vpc_id
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
