locals {
  namespace     = "useast1d"
  app_role      = "wordpress"
  region        = "us-east-1"
  lob           = "it_operations"
  team          = "web_hosting"
  environment   = "development"
  instance_type = "t3.large"
  asg_size      = 3

  default_tags = {
    namespace : local.namespace,
    app_role : local.app_role,
    lob : local.lob,
    team : local.team,
    environment : local.environment
  }
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

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
