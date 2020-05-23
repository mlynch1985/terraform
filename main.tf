## Setup our environment variables
variable "namespace" { default = "useast1d" }
variable "environment" { default = "dev" }
variable "region" { default = "us-east-1" }
variable "office_ip" { default = "192.168.0.0/24" }

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

module "base" {
  source = "./base"
  namespace = var.namespace
  environment = var.environment
  region = var.region
  office_ip = var.office_ip
}
