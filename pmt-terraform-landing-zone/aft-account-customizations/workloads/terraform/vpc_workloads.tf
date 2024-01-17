# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  # Allows us to use the SSM Parameter in our vpc_workloads module
  network_account_id = nonsensitive(data.aws_ssm_parameter.network_account_id.value)
  tgw_asn            = nonsensitive(data.aws_ssm_parameter.tgw_asn.value)
}

data "aws_ssm_parameter" "network_account_id" {
  name = "/aft/account-request/custom-fields/network_account_id"
}

data "aws_ssm_parameter" "tgw_asn" {
  name = "/aft/account-request/custom-fields/tgw_asn"
}

data "aws_vpc_ipam_pool" "region1" {
  filter {
    name   = "locale"
    values = [local.region1_name]
  }
}

data "aws_vpc_ipam_pool" "region2" {
  filter {
    name   = "locale"
    values = [local.region2_name]
  }
}

module "vpc_workload_region1" {
  source = "../../modules/vpc_workloads"

  name                 = "workload"
  azs                  = local.region1_az_zone_ids
  ipam_pool_id         = data.aws_vpc_ipam_pool.region1.id
  private_subnet_names = ["workload_private_a", "workload_private_b", "workload_private_c"]
  transit_subnet_names = ["workload_transit_a", "workload_transit_b", "workload_transit_c"]
  network_account_id   = local.network_account_id
  tgw_asn              = local.tgw_asn

  providers = {
    aws = aws.region1
  }
}

module "vpc_workload_region2" {
  source = "../../modules/vpc_workloads"

  name                 = "workload"
  azs                  = local.region2_az_zone_ids
  ipam_pool_id         = data.aws_vpc_ipam_pool.region2.id
  private_subnet_names = ["workload_private_a", "workload_private_b", "workload_private_c"]
  transit_subnet_names = ["workload_transit_a", "workload_transit_b", "workload_transit_c"]
  network_account_id   = local.network_account_id
  tgw_asn              = local.tgw_asn

  providers = {
    aws = aws.region2
  }
}

module "vpc_workload_flowlogs_region1" {
  source = "../../modules/vpc_flow_logs"

  name   = "workload"
  vpc_id = module.vpc_workload_region1.vpc_id

  providers = {
    aws = aws.region1
  }
}

module "vpc_workload_flowlogs_region2" {
  source = "../../modules/vpc_flow_logs"

  name   = "workload"
  vpc_id = module.vpc_workload_region2.vpc_id

  providers = {
    aws = aws.region2
  }
}

module "vpc_workload_flowlog_cloudwatch_alarms_region1" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region1.arn]
  vpc_flowlog_groups = [module.vpc_workload_flowlogs_region1.cloudwatch_log_group_name]
  vpc_name           = "workload"

  providers = {
    aws = aws.region1
  }
}

module "vpc_workload_flowlog_cloudwatch_alarms_region2" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region2.arn]
  vpc_flowlog_groups = [module.vpc_workload_flowlogs_region2.cloudwatch_log_group_name]
  vpc_name           = "workload"

  providers = {
    aws = aws.region2
  }
}
