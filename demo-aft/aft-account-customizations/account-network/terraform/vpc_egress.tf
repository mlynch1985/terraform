# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

###################################
#####     DEV Egress VPCs     #####
###################################

module "dev_vpc_egress_region1" {
  source = "./modules/vpc_egress"

  name                            = "dev_egress"
  domain                          = "dev"
  azs                             = slice(data.aws_availability_zones.region1.zone_ids, 0, 3)
  ipam_pool_id                    = module.dev_ipam.pools_level_2["${local.global_vars.region1}/Infrastructure_Dev"].id
  public_subnet_names             = ["dev_egress_public_a", "dev_egress_public_b", "dev_egress_public_c"]
  transit_subnet_names            = ["dev_egress_transit_a", "dev_egress_transit_b", "dev_egress_transit_c"]
  tgw_cidr_route                  = local.ipam_root_cidr
  tgw_id                          = module.tgw_dev_region1.ec2_transit_gateway_id
  tgw_default_route_attachment_id = module.dev_vpc_inspection_region1.tgw_attachment_id
  tgw_inspection_tbl_id           = module.dev_vpc_inspection_region1.tgw_route_table_id

  providers = {
    aws = aws.region1
  }
}

module "dev_vpc_egress_region2" {
  source = "./modules/vpc_egress"

  name                            = "dev_egress"
  domain                          = "dev"
  azs                             = slice(data.aws_availability_zones.region2.zone_ids, 0, 3)
  ipam_pool_id                    = module.dev_ipam.pools_level_2["${local.global_vars.region2}/Infrastructure_Dev"].id
  public_subnet_names             = ["dev_egress_public_a", "dev_egress_public_b", "dev_egress_public_c"]
  transit_subnet_names            = ["dev_egress_transit_a", "dev_egress_transit_b", "dev_egress_transit_c"]
  tgw_cidr_route                  = local.ipam_root_cidr
  tgw_id                          = module.tgw_dev_region2.ec2_transit_gateway_id
  tgw_default_route_attachment_id = module.dev_vpc_inspection_region2.tgw_attachment_id
  tgw_inspection_tbl_id           = module.dev_vpc_inspection_region2.tgw_route_table_id

  providers = {
    aws = aws.region2
  }
}

module "dev_vpc_egress_region3" {
  source = "./modules/vpc_egress"

  name                            = "dev_egress"
  domain                          = "dev"
  azs                             = slice(data.aws_availability_zones.region3.zone_ids, 0, 3)
  ipam_pool_id                    = module.dev_ipam.pools_level_2["${local.global_vars.region3}/Infrastructure_Dev"].id
  public_subnet_names             = ["dev_egress_public_a", "dev_egress_public_b", "dev_egress_public_c"]
  transit_subnet_names            = ["dev_egress_transit_a", "dev_egress_transit_b", "dev_egress_transit_c"]
  tgw_cidr_route                  = local.ipam_root_cidr
  tgw_id                          = module.tgw_dev_region3.ec2_transit_gateway_id
  tgw_default_route_attachment_id = module.dev_vpc_inspection_region3.tgw_attachment_id
  tgw_inspection_tbl_id           = module.dev_vpc_inspection_region3.tgw_route_table_id

  providers = {
    aws = aws.region3
  }
}

# module "dev_vpc_egress_region4" {
#   source = "./modules/vpc_egress"

#   name                            = "dev_egress"
#   domain                          = "dev"
#   azs                             = slice(data.aws_availability_zones.region4.zone_ids, 0, 3)
#   ipam_pool_id                    = module.dev_ipam.pools_level_2["${local.global_vars.region4}/Infrastructure_Dev"].id
#   public_subnet_names             = ["dev_egress_public_a", "dev_egress_public_b", "dev_egress_public_c"]
#   transit_subnet_names            = ["dev_egress_transit_a", "dev_egress_transit_b", "dev_egress_transit_c"]
#   tgw_cidr_route                  = local.ipam_root_cidr
#   tgw_id                          = module.tgw_dev_region4.ec2_transit_gateway_id
#   tgw_default_route_attachment_id = module.dev_vpc_inspection_region4.tgw_attachment_id
#   tgw_inspection_tbl_id           = module.dev_vpc_inspection_region4.tgw_route_table_id

#   providers = {
#     aws = aws.region4
#   }
# }
