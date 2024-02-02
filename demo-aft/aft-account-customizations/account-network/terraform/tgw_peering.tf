# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

#####################################################
#########     DEV Peering Attachements     ##########
#####################################################

resource "aws_ec2_transit_gateway_peering_attachment" "dev_peering_region1_region2" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.global_vars.region2
  transit_gateway_id      = module.tgw_dev_region1.ec2_transit_gateway_id
  peer_transit_gateway_id = module.tgw_dev_region2.ec2_transit_gateway_id

  tags = {
    "Name" = "dev_peering_region1_region2"
    Domain = "dev"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_peering_attachment" "dev_peering_region1_region3" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.global_vars.region3
  transit_gateway_id      = module.tgw_dev_region1.ec2_transit_gateway_id
  peer_transit_gateway_id = module.tgw_dev_region3.ec2_transit_gateway_id

  tags = {
    "Name" = "dev_peering_region1_region3"
    Domain = "dev"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_peering_attachment" "dev_peering_region2_region3" {
  peer_account_id         = data.aws_caller_identity.current.account_id
  peer_region             = local.global_vars.region3
  transit_gateway_id      = module.tgw_dev_region2.ec2_transit_gateway_id
  peer_transit_gateway_id = module.tgw_dev_region3.ec2_transit_gateway_id

  tags = {
    "Name" = "dev_peering_region2_region3"
    Domain = "dev"
  }

  provider = aws.region2
}

##################################################
#########     DEV Peering Accepters     ##########
##################################################

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "dev_peering_region2_region1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region2.id

  tags = {
    "Name" = "dev_peering_region2_region1"
    Domain = "dev"
  }

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "dev_peering_region3_region1" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region3.id

  tags = {
    "Name" = "dev_peering_region2_region1"
    Domain = "dev"
  }

  provider = aws.region3
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "dev_peering_region3_region2" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.dev_peering_region2_region3.id

  tags = {
    "Name" = "dev_peering_region3_region2"
    Domain = "dev"
  }

  provider = aws.region3
}
