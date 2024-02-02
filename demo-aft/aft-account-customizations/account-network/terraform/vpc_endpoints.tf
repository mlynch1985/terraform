# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  vpc_endpoints_list = [
    "autoscaling",
    "codecommit",
    "git-codecommit",
    "ec2",
    "ec2messages",
    "events",
    "kms",
    "lambda",
    "rds",
    "rds-data",
    "secretsmanager",
    "sts",
    "sns",
    "sqs",
    "ssm",
    "ssmmessages"
  ]
}

module "dev_vpc_endpoints_region1" {
  source = "./modules/vpc_endpoints"
  providers = {
    aws = aws.region1
  }

  domain                   = "dev"
  ram_share_principals     = [local.all_ous["Infrastructure"].arn, local.all_ous["Workloads/Dev"].arn]
  sg_inbound_source_cidrs  = [local.ipam_root_cidr]
  sg_outbound_source_cidrs = [local.ipam_root_cidr]
  subnet_ids               = [for subnet_id in module.dev_vpc_shared_services_region1.private_subnets : subnet_id]
  vpc_id                   = module.dev_vpc_shared_services_region1.vpc_id

  vpc_endpoints = local.vpc_endpoints_list
}

module "dev_vpc_endpoints_region2" {
  source = "./modules/vpc_endpoints"
  providers = {
    aws = aws.region2
  }

  domain                   = "dev"
  ram_share_principals     = [local.all_ous["Infrastructure"].arn, local.all_ous["Workloads/Dev"].arn]
  sg_inbound_source_cidrs  = [local.ipam_root_cidr]
  sg_outbound_source_cidrs = [local.ipam_root_cidr]
  subnet_ids               = [for subnet_id in module.dev_vpc_shared_services_region2.private_subnets : subnet_id]
  vpc_id                   = module.dev_vpc_shared_services_region2.vpc_id

  vpc_endpoints = local.vpc_endpoints_list
}

module "dev_vpc_endpoints_region3" {
  source = "./modules/vpc_endpoints"
  providers = {
    aws = aws.region3
  }

  domain                   = "dev"
  ram_share_principals     = [local.all_ous["Infrastructure"].arn, local.all_ous["Workloads/Dev"].arn]
  sg_inbound_source_cidrs  = [local.ipam_root_cidr]
  sg_outbound_source_cidrs = [local.ipam_root_cidr]
  subnet_ids               = [for subnet_id in module.dev_vpc_shared_services_region3.private_subnets : subnet_id]
  vpc_id                   = module.dev_vpc_shared_services_region3.vpc_id

  vpc_endpoints = local.vpc_endpoints_list
}

# module "dev_vpc_endpoints_region4" {
#   source = "./modules/vpc_endpoints"
#   providers = {
#     aws = aws.region4
#   }

#   domain                   = "dev"
#   ram_share_principals     = [local.all_ous["Infrastructure"].arn, local.all_ous["Workloads/Dev"].arn]
#   sg_inbound_source_cidrs  = [local.ipam_root_cidr]
#   sg_outbound_source_cidrs = [local.ipam_root_cidr]
#   subnet_ids               = [for subnet_id in module.dev_vpc_shared_services_region4.private_subnets : subnet_id]
#   vpc_id                   = module.dev_vpc_shared_services_region4.vpc_id

#   vpc_endpoints = local.vpc_endpoints_list
# }
