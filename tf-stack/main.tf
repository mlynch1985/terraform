##### Main Terraform Entry Point #####

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

    default_tags = var.default_tags
    region = var.region
    cidr_block = var.cidr_block
    az_list = data.aws_availability_zones.available
    az_count = var.az_count
}

module "wordpress" {
    source = "./wordpress"

    default_tags = var.default_tags
    region = var.region
    account_id = data.aws_caller_identity.current.account_id
    common_security_group = module.vpc.sg_common
    public_subnets = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
    vpc_id = module.vpc.vpc
}
