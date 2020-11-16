terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}

module "vpc" {
  source = "../../modules/vpc"

  namespace                = var.namespace
  default_tags             = local.default_tags
  cidr_block               = "10.0.0.0/16"
  deploy_private_subnets   = true
  deploy_protected_subnets = false
  enable_flow_logs         = true
}
