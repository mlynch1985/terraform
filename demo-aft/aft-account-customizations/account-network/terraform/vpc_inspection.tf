# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

#######################################
#####     DEV Inspection VPCs     #####
#######################################

module "dev_vpc_inspection_region1" {
  source = "./modules/vpc_inspection"

  name                       = "dev_inspection"
  domain                     = "dev"
  azs                        = slice(data.aws_availability_zones.region1.zone_ids, 0, 3)
  firewall_delete_protection = false # Testing
  firewall_enabled           = false # Testing
  ipam_pool_id               = module.dev_ipam.pools_level_2["${local.global_vars.region1}/Infrastructure_Dev"].id
  private_subnet_names       = ["dev_inspection_private_a", "dev_inspection_private_b", "dev_inspection_private_c"]
  transit_subnet_names       = ["dev_inspection_transit_a", "dev_inspection_transit_b", "dev_inspection_transit_c"]
  tgw_cidr_route             = local.ipam_root_cidr
  tgw_id                     = module.tgw_dev_region1.ec2_transit_gateway_id

  providers = {
    aws = aws.region1
  }
}

module "dev_vpc_inspection_region2" {
  source = "./modules/vpc_inspection"

  name                       = "dev_inspection"
  domain                     = "dev"
  azs                        = slice(data.aws_availability_zones.region2.zone_ids, 0, 3)
  firewall_delete_protection = false # Testing
  firewall_enabled           = false # Testing
  ipam_pool_id               = module.dev_ipam.pools_level_2["${local.global_vars.region2}/Infrastructure_Dev"].id
  private_subnet_names       = ["dev_inspection_private_a", "dev_inspection_private_b", "dev_inspection_private_c"]
  transit_subnet_names       = ["dev_inspection_transit_a", "dev_inspection_transit_b", "dev_inspection_transit_c"]
  tgw_cidr_route             = local.ipam_root_cidr
  tgw_id                     = module.tgw_dev_region2.ec2_transit_gateway_id

  providers = {
    aws = aws.region2
  }

  depends_on = [module.dev_vpc_inspection_region1.aws_networkfirewall_firewall] # Race condition when creating NetFW Service Linked role
}

module "dev_vpc_inspection_region3" {
  source = "./modules/vpc_inspection"

  name                       = "dev_inspection"
  domain                     = "dev"
  azs                        = slice(data.aws_availability_zones.region3.zone_ids, 0, 3)
  firewall_delete_protection = false # Testing
  firewall_enabled           = false # Testing
  ipam_pool_id               = module.dev_ipam.pools_level_2["${local.global_vars.region3}/Infrastructure_Dev"].id
  private_subnet_names       = ["dev_inspection_private_a", "dev_inspection_private_b", "dev_inspection_private_c"]
  transit_subnet_names       = ["dev_inspection_transit_a", "dev_inspection_transit_b", "dev_inspection_transit_c"]
  tgw_cidr_route             = local.ipam_root_cidr
  tgw_id                     = module.tgw_dev_region3.ec2_transit_gateway_id

  providers = {
    aws = aws.region3
  }

  depends_on = [module.dev_vpc_inspection_region1.aws_networkfirewall_firewall] # Race condition when creating NetFW Service Linked role
}

# module "dev_vpc_inspection_region4" {
#   source = "./modules/vpc_inspection"

#   name                       = "dev_inspection"
#   domain                     = "dev"
#   azs                        = slice(data.aws_availability_zones.region4.zone_ids, 0, 3)
#   firewall_delete_protection = false # Testing
#   firewall_enabled = false # Testing
#   ipam_pool_id               = module.dev_ipam.pools_level_2["${local.global_vars.region4}/Infrastructure_Dev"].id
#   private_subnet_names       = ["dev_inspection_private_a", "dev_inspection_private_b", "dev_inspection_private_c"]
#   transit_subnet_names       = ["dev_inspection_transit_a", "dev_inspection_transit_b", "dev_inspection_transit_c"]
#   tgw_cidr_route             = local.ipam_root_cidr
#   tgw_id                     = module.tgw_dev_region4.ec2_transit_gateway_id

#   providers = {
#     aws = aws.region4
#   }

#   depends_on = [module.dev_vpc_inspection_region1.aws_networkfirewall_firewall] # Race condition when creating NetFW Service Linked role
# }


# Apply these after Egress VPCs are created to avoid a circular reference
resource "aws_ec2_transit_gateway_route" "dev_vpc_inspection_region1" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_egress_region1.tgw_attachment_id # Egress VPC or OnPrem network
  transit_gateway_route_table_id = module.dev_vpc_inspection_region1.tgw_route_table_id

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_route" "dev_vpc_inspection_region2" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_egress_region2.tgw_attachment_id # Egress VPC or OnPrem network
  transit_gateway_route_table_id = module.dev_vpc_inspection_region2.tgw_route_table_id

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_route" "dev_vpc_inspection_region3" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_egress_region3.tgw_attachment_id # Egress VPC or OnPrem network
  transit_gateway_route_table_id = module.dev_vpc_inspection_region3.tgw_route_table_id

  provider = aws.region3
}

# resource "aws_ec2_transit_gateway_route" "dev_vpc_inspection_region4" {
#   destination_cidr_block         = "0.0.0.0/0"
#   transit_gateway_attachment_id  = module.dev_vpc_egress_region4.tgw_attachment_id # Egress VPC or OnPrem network
#   transit_gateway_route_table_id = module.dev_vpc_inspection_region4.tgw_route_table_id

#   provider = aws.region4
# }
