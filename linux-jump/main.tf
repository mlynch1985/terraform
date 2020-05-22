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
#     key    = "useast1d-state-linuxjump"
#     region = "us-east-1"
#   }
# }

## Specify any DATA elements here to be shared across all components of this module

## Query for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
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

## Query for allow_vpc_ssh Security Group
data "aws_security_group" "allow_vpc_ssh" {
  tags = {
    Name        = "${var.namespace}_allow_vpc_ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Query for allow_office_ssh Security Group
data "aws_security_group" "allow_office_ssh" {
  tags = {
    Name        = "${var.namespace}_allow_office_ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
