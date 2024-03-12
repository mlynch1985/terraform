# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


module "vpc_region1" {
  source = "../../modules/vpc_workload_default"

  azs                   = slice(data.aws_availability_zones.region1.zone_ids, 0, 3)
  domain                = "dev"
  ipam_pool_id          = data.aws_vpc_ipam_pool.region1.id
  name                  = "dev_default_vpc"
  network_account_id    = local.network_account_id
  private_subnet_names  = ["dev_default_private_a", "dev_default_private_b", "dev_default_private_c"]
  transit_subnet_names  = ["dev_default_transit_a", "dev_default_transit_b", "dev_default_transit_c"]
  tgw_id                = data.aws_ec2_transit_gateway.region1.id
  tgw_default_rtb_id    = data.aws_ec2_transit_gateway_route_table.default_region1.id
  tgw_inspection_rtb_id = data.aws_ec2_transit_gateway_route_table.inspection_region1.id

  providers = {
    aws               = aws.region1
    aws.network       = aws.network-region1
    aws.ct-management = aws.ct-management
  }
}

module "vpc_region2" {
  source = "../../modules/vpc_workload_default"

  azs                   = slice(data.aws_availability_zones.region2.zone_ids, 0, 3)
  domain                = "dev"
  ipam_pool_id          = data.aws_vpc_ipam_pool.region2.id
  name                  = "dev_default_vpc"
  network_account_id    = local.network_account_id
  private_subnet_names  = ["dev_default_private_a", "dev_default_private_b", "dev_default_private_c"]
  transit_subnet_names  = ["dev_default_transit_a", "dev_default_transit_b", "dev_default_transit_c"]
  tgw_id                = data.aws_ec2_transit_gateway.region2.id
  tgw_default_rtb_id    = data.aws_ec2_transit_gateway_route_table.default_region2.id
  tgw_inspection_rtb_id = data.aws_ec2_transit_gateway_route_table.inspection_region2.id

  providers = {
    aws               = aws.region2
    aws.network       = aws.network-region2
    aws.ct-management = aws.ct-management
  }
}

module "vpc_region3" {
  source = "../../modules/vpc_workload_default"

  azs                   = slice(data.aws_availability_zones.region3.zone_ids, 0, 3)
  domain                = "dev"
  ipam_pool_id          = data.aws_vpc_ipam_pool.region3.id
  name                  = "dev_default_vpc"
  network_account_id    = local.network_account_id
  private_subnet_names  = ["dev_default_private_a", "dev_default_private_b", "dev_default_private_c"]
  transit_subnet_names  = ["dev_default_transit_a", "dev_default_transit_b", "dev_default_transit_c"]
  tgw_id                = data.aws_ec2_transit_gateway.region3.id
  tgw_default_rtb_id    = data.aws_ec2_transit_gateway_route_table.default_region3.id
  tgw_inspection_rtb_id = data.aws_ec2_transit_gateway_route_table.inspection_region3.id

  providers = {
    aws               = aws.region3
    aws.network       = aws.network-region3
    aws.ct-management = aws.ct-management
  }
}

# module "vpc_region4" {
#   source = "../../modules/vpc_workload_default"

#   azs                     = slice(data.aws_availability_zones.region4.zone_ids, 0, 3)
#   domain                  = "dev"
#   ipam_pool_id            = data.aws_vpc_ipam_pool.region4.id
#   name                    = "dev_default_vpc"
#   network_account_id      = local.network_account_id
#   private_subnet_names    = ["dev_default_private_a", "dev_default_private_b", "dev_default_private_c"]
#   transit_subnet_names    = ["dev_default_transit_a", "dev_default_transit_b", "dev_default_transit_c"]
#   tgw_id                  = data.aws_ec2_transit_gateway.region4.id
#   tgw_default_rtb_id      = data.aws_ec2_transit_gateway_route_table.default_region4.id
#   tgw_inspection_rtb_id   = data.aws_ec2_transit_gateway_route_table.inspection_region4.id

#   providers = {
#     aws         = aws.region4
#     aws.network = aws.network-region4
#     aws.ct-management = aws.ct-management
#   }
# }
