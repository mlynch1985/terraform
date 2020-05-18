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

## Query for our VPC
data "aws_vpc" "vpc" {
  tags = {
    Name        = "${var.namespace}-vpc"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
