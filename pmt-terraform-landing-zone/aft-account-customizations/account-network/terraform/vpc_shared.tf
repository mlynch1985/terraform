# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "vpc_shared_region1" {
  source = "../../modules/vpc_workloads"

  name                  = "shared"
  azs                   = local.region1_az_zone_ids
  ipam_pool_id          = module.ipam.pools_level_2["${local.region1_name}/infrastructure"].id
  private_subnet_names  = ["shared_private_a", "shared_private_b", "shared_private_c"]
  transit_subnet_names  = ["shared_transit_a", "shared_transit_b", "shared_transit_c"]
  network_account_id    = data.aws_caller_identity.current.account_id
  tgw_asn               = module.tgw_nonprod_region1.ec2_transit_gateway_asn
  auto_enable_tgw_route = false

  providers = {
    aws = aws.region1
  }

  depends_on = [module.tgw_nonprod_region1]
}

module "vpc_shared_region2" {
  source = "../../modules/vpc_workloads"

  name                  = "shared"
  azs                   = local.region2_az_zone_ids
  ipam_pool_id          = module.ipam.pools_level_2["${local.region2_name}/infrastructure"].id
  private_subnet_names  = ["shared_private_a", "shared_private_b", "shared_private_c"]
  transit_subnet_names  = ["shared_transit_a", "shared_transit_b", "shared_transit_c"]
  network_account_id    = data.aws_caller_identity.current.account_id
  tgw_asn               = module.tgw_nonprod_region2.ec2_transit_gateway_asn
  auto_enable_tgw_route = false

  providers = {
    aws = aws.region2
  }

  depends_on = [module.tgw_nonprod_region2]
}

module "vpc_shared_flowlogs_region1" {
  source = "../../modules/vpc_flow_logs"

  name   = "shared"
  vpc_id = module.vpc_shared_region1.vpc_id

  providers = {
    aws = aws.region1
  }
}

module "vpc_shared_flowlogs_region2" {
  source = "../../modules/vpc_flow_logs"

  name   = "shared"
  vpc_id = module.vpc_shared_region2.vpc_id

  providers = {
    aws = aws.region2
  }
}

module "vpc_shared_flowlog_cloudwatch_alarms_region1" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region1.arn]
  vpc_flowlog_groups = [module.vpc_shared_flowlogs_region1.cloudwatch_log_group_name]
  vpc_name           = "shared"

  providers = {
    aws = aws.region1
  }
}

module "vpc_shared_flowlog_cloudwatch_alarms_region2" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region2.arn]
  vpc_flowlog_groups = [module.vpc_shared_flowlogs_region2.cloudwatch_log_group_name]
  vpc_name           = "shared"

  providers = {
    aws = aws.region2
  }
}
