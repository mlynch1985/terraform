variable region {}
variable namespace {}
variable bucket {}
variable lob {}
variable team {}
variable environment {}

locals {
  component     = "winiis"
  domain_name   = "example.internal"
  instance_type = "t3.large"

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

data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}
