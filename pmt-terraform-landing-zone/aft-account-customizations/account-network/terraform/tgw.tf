# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "tgw_region1" {
  source = "./modules/tgw"

  name            = "transit"
  amazon_side_asn = 64513
  ram_name        = "tgw"
  ram_principals = [
    local.exceptions_arn,
    local.sandbox_arn,
    local.deployments_arn,
    local.infrastructure_arn,
    local.policy_staging_arn,
    local.suspended_arn,
    local.workloads_arn
  ]

  providers = {
    aws = aws.region1
  }
}

module "tgw_region2" {
  source = "./modules/tgw"

  name            = "transit"
  amazon_side_asn = 64513
  ram_name        = "tgw"
  ram_principals = [
    local.exceptions_arn,
    local.sandbox_arn,
    local.deployments_arn,
    local.infrastructure_arn,
    local.policy_staging_arn,
    local.suspended_arn,
    local.workloads_arn
  ]

  providers = {
    aws = aws.region2
  }
}

resource "aws_ec2_transit_gateway_peering_attachment" "region1_to_region2" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.region2_name
  transit_gateway_id      = module.tgw_region1.ec2_transit_gateway_id
  peer_transit_gateway_id = module.tgw_region2.ec2_transit_gateway_id

  tags = {
    "Name" = "tgw_peer_region1_to_region2"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "region2_to_region1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.region1_to_region2.id

  tags = {
    "Name" = "tgw_peer_region2_to_region1"
  }

  provider = aws.region2
}
