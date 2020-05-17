## Setup our environment variables
variable "namespace" { default = "test" }
variable "environment" { default = "dev" }
variable "region" { default = "us-east-1" }

## Capture current user executing code
data "aws_caller_identity" "current" {}

## Setup our connection to AWS account
provider "aws" {
  region  = var.region
  version = "~> 2.62"
}
