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
#     key    = "useast1d-state-base"
#     region = "us-east-1"
#   }
# }

## Create our base S3 Bucket to hold configuration scripts/files
resource "aws_s3_bucket" "s3_configfiles" {
  bucket = "${var.namespace}-mltemp"
  acl    = "private"

  tags = {
    Name        = "${var.namespace}-mltemp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Capture currently availability zones
data "aws_availability_zones" "zones" {
  state = "available"
}
