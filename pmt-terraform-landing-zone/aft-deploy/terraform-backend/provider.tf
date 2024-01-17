terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17"
    }
  }
  required_version = ">= 1.5.7"
}

provider "aws" {
  version                 = "~> 5.17"
  region                  = "us-east-1"
}