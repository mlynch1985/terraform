variable region {}
variable namespace {}
variable bucket {}
variable lob {}
variable team {}
variable environment {}

locals {
  component     = "wordpress"
  instance_type = "t3.large"
  asg_min       = 3
  asg_max       = 3
  asg_desired   = 3

  default_tags = {
    namespace : var.namespace,
    component : local.component,
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
