terraform {
  # backend "s3" {
  #   bucket         = "useast1d-tf-state"
  #   key            = "vpc-dev"
  #   region         = "us-east-1"
  #   encrypt        = "true"
  #   dynamodb_table = "useast1d-terraform-locks"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  namespace                = local.namespace
  default_tags             = local.default_tags
  cidr_block               = "10.0.0.0/20"
  enable_dns_support       = true
  enable_dns_hostnames     = true
  target_az_count          = 3
  deploy_private_subnets   = true
  deploy_protected_subnets = true
  enable_flow_logs         = true
}
