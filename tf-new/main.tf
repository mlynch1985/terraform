terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  namespace = var.namespace
  default_tags = local.default_tags
  cidr_block = "10.0.0.0/16"
  deploy_public_subnets = true
  deploy_private_subnets = true
  deploy_protected_subnets = true
}