# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "vpc_egress_region1" {
  source = "../../modules/vpc_egress"

  name                 = "egress"
  azs                  = local.region1_az_zone_ids
  ipam_pool_id         = module.ipam.pools_level_2["${local.region1_name}/infrastructure"].id
  public_subnet_names  = ["egress_public_a", "egress_public_b", "egress_public_c"]
  transit_subnet_names = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  tgw_cidr_route       = data.aws_ssm_parameter.ipam_root_cidr.value
  tgw_id               = module.tgw_nonprod_region1.ec2_transit_gateway_id

  providers = {
    aws = aws.region1
  }
}

module "vpc_egress_region2" {
  source = "../../modules/vpc_egress"

  name                 = "egress"
  azs                  = local.region2_az_zone_ids
  ipam_pool_id         = module.ipam.pools_level_2["${local.region2_name}/infrastructure"].id
  public_subnet_names  = ["egress_public_a", "egress_public_b", "egress_public_c"]
  transit_subnet_names = ["egress_transit_a", "egress_transit_b", "egress_transit_c"]
  tgw_cidr_route       = data.aws_ssm_parameter.ipam_root_cidr.value
  tgw_id               = module.tgw_nonprod_region2.ec2_transit_gateway_id

  providers = {
    aws = aws.region2
  }
}

module "vpc_egress_flowlogs_region1" {
  source = "../../modules/vpc_flow_logs"

  name   = "egress"
  vpc_id = module.vpc_egress_region1.vpc_id

  providers = {
    aws = aws.region1
  }
}

module "vpc_egress_flowlogs_region2" {
  source = "../../modules/vpc_flow_logs"

  name   = "egress"
  vpc_id = module.vpc_egress_region2.vpc_id

  providers = {
    aws = aws.region2
  }
}

module "vpc_egress_flowlog_cloudwatch_alarms_region1" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region1.arn]
  vpc_flowlog_groups = [module.vpc_egress_flowlogs_region1.cloudwatch_log_group_name]
  vpc_name           = "egress"

  providers = {
    aws = aws.region1
  }
}

module "vpc_egress_flowlog_cloudwatch_alarms_region2" {
  source = "../../modules/vpc_flowlog_cloudwatch_alarms"

  alarm_actions      = [data.aws_sns_topic.aws_controltower_securitynotification_region2.arn]
  vpc_flowlog_groups = [module.vpc_egress_flowlogs_region2.cloudwatch_log_group_name]
  vpc_name           = "egress"

  providers = {
    aws = aws.region2
  }
}
