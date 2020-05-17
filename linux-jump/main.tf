## Setup our environment variables
variable "namespace" { default = "test" }
variable "environment" { default = "dev" }
variable "region" { default = "us-east-1" }
variable "office-ip" {}

## Capture current user executing code
data "aws_caller_identity" "current" {}

## Setup our connection to AWS account
provider "aws" {
  region  = var.region
  version = "~> 2.62"
}

## Specify any DATA elements here to be shared across all components of this module

## Query for the latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
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

## Query for our Allow_SSH Security Group
data "aws_security_group" "sg-allow-ssh" {
  tags = {
    Name        = "${var.namespace}-allow-ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
