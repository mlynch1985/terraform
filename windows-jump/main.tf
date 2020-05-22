## Setup our environment variables
variable "namespace" { default = "useast1d" }
variable "environment" { default = "dev" }
variable "region" { default = "us-east-1" }
variable "office_ip" { default = "192.168.0.0/24" }

## Capture current user executing code
data "aws_caller_identity" "current" {}

## Setup our connection to AWS account
provider "aws" {
  region  = var.region
  version = "~> 2.62"
}

# terraform {
#   backend "s3" {
#     bucket = "useast1d-mltemp"
#     key    = "useast1d-state-windowsjump"
#     region = "us-east-1"
#   }
# }

## Specify any DATA elements here to be shared across all components of this module

## Query for the latest Windows Server 2019 AMI
data "aws_ami" "windows_server_2019_ami" {
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
    Name        = "${var.namespace}_vpc"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for public subnets
data "aws_subnet_ids" "subnets_public" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier        = "public"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for private subnets
data "aws_subnet_ids" "subnets_private" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier        = "private"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for allow_vpc_rdp Security Group
data "aws_security_group" "allow_vpc_rdp" {
  tags = {
    Name        = "${var.namespace}_allow_vpc_rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for allow_office_rdp Security Group
data "aws_security_group" "allow_office_rdp" {
  tags = {
    Name        = "${var.namespace}_allow_office_rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for WindowsJump Secret created by Cloudformation Stack
data "aws_secretsmanager_secret" "windowsjump" {
  name = "useast1d-windowsjump"
  depends_on = [
    aws_cloudformation_stack.windowsjump
  ]
}
