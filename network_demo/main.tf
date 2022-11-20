terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.40.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Creator      = var.creator
      Environment  = var.environment
      Namespace    = var.namespace
      Organization = var.organization
      Owner        = var.owner
    }
  }
}

module "ipam" {
  source = "./modules/ipam/"

  allocation_default_netmask_length = 16
  cidr                              = "10.0.0.0/8"
  region                            = var.region
}

module "vpc-hub" {
  source = "./modules/vpc-hub/"

  ipam_pool_id       = module.ipam.pool_id
  ipam_pool_netmask  = 16
  subnet_size_offset = 4
  target_az_count    = 4
  tgw_cidr           = module.ipam.cidr
}

module "vpc-spoke1" {
  source = "./modules/vpc-spoke/"

  ipam_pool_id       = module.ipam.pool_id
  ipam_pool_netmask  = 16
  subnet_size_offset = 4
  target_az_count    = 4
  tgw_id             = module.vpc-hub.tgw_id
}

module "vpc-flow-logs" {
  source = "./modules/vpc-logs/"

  region  = var.region
  vpc_ids = [module.vpc-hub.vpc_id, module.vpc-spoke1.vpc_id]
}
