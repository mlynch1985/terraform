terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket = "mltest-tf-state"
    key    = "arcus-state"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.region
}
