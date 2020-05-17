## Specify any DATA elements here to be shared across all components of this module

## Query for the latest Windows Server 2019 AMI
data "aws_ami" "windows-server-2019-ami" {
  most_recent = true
  owners      = ["801119661308"]

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

## Query for our VPC
data "aws_vpc" "vpc" {
  tags = {
    Name        = "${var.namespace}-vpc"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for public subnets
data "aws_subnet_ids" "public-subnets" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier        = "public"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for private subnets
data "aws_subnet_ids" "private-subnets" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier        = "private"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for our RDP Security Group
data "aws_security_group" "sg-allow-rdp" {
  tags = {
    Name        = "${var.namespace}-allow-rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
