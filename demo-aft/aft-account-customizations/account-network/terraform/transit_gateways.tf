# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

#################################################
#########     DEV Transit Gateways     ##########
#################################################

module "tgw_dev_region1" {
  source = "./modules/tgw"

  name            = "dev"
  domain          = "dev"
  amazon_side_asn = 64513
  ram_name        = "tgw_dev"
  ram_principals = [
    local.all_ous["Infrastructure"].arn,
    local.all_ous["Workloads/Dev"].arn
  ]

  providers = {
    aws = aws.region1
  }
}

module "tgw_dev_region2" {
  source = "./modules/tgw"

  name            = "dev"
  domain          = "dev"
  amazon_side_asn = 64513
  ram_name        = "tgw_dev"
  ram_principals = [
    local.all_ous["Infrastructure"].arn,
    local.all_ous["Workloads/Dev"].arn
  ]

  providers = {
    aws = aws.region2
  }
}

module "tgw_dev_region3" {
  source = "./modules/tgw"

  name            = "dev"
  domain          = "dev"
  amazon_side_asn = 64513
  ram_name        = "tgw_dev"
  ram_principals = [
    local.all_ous["Infrastructure"].arn,
    local.all_ous["Workloads/Dev"].arn
  ]

  providers = {
    aws = aws.region3
  }
}

# module "tgw_dev_region4" {
#   source = "./modules/tgw"

#   name            = "dev"
#   domain          = "dev"
#   amazon_side_asn = 64513
#   ram_name        = "tgw_dev"
#   ram_principals = [
#     local.all_ous["Infrastructure"].arn,
#     local.all_ous["Workloads/Dev"].arn
#   ]

#   providers = {
#     aws = aws.region4
#   }
# }

resource "aws_ec2_transit_gateway_route_table" "dev_default_region1" {
  transit_gateway_id = module.tgw_dev_region1.ec2_transit_gateway_id

  tags = {
    Name   = "dev_default"
    Domain = "dev"
    Type   = "Default"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_route_table" "dev_default_region2" {
  transit_gateway_id = module.tgw_dev_region2.ec2_transit_gateway_id

  tags = {
    Name   = "dev_default"
    Domain = "dev"
    Type   = "Default"
  }

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_route_table" "dev_default_region3" {
  transit_gateway_id = module.tgw_dev_region3.ec2_transit_gateway_id

  tags = {
    Name   = "dev_default"
    Domain = "dev"
    Type   = "Default"
  }

  provider = aws.region3
}

# resource "aws_ec2_transit_gateway_route_table" "dev_default_region4" {
#   transit_gateway_id = module.tgw_dev_region4.ec2_transit_gateway_id

#   tags = {
#     Name   = "dev_tgw_rtb_default"
#     Domain = "dev"
#     Type   = "Default"
#   }

#   provider = aws.region4
# }

resource "aws_ec2_transit_gateway_route" "dev_default_region1" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region1.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_default_region1.id

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_route" "dev_default_region2" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region2.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_default_region2.id

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_route" "dev_default_region3" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region3.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_default_region3.id

  provider = aws.region3
}

# resource "aws_ec2_transit_gateway_route" "dev_default_region4" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = module.dev_vpc_inspection_region4.tgw_attachment_id
#   transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_default_region4.id

#   provider = aws.region4
# }
