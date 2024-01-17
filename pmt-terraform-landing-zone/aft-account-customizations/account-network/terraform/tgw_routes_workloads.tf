# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Loop through list of IPAM CIDRs filtered by VPC ID and return the correspond TGW Attachment if its in the "available" state
data "aws_ec2_transit_gateway_vpc_attachment" "workloads_region1" {
  for_each = local.ipam_cidrs_region1

  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "vpc-id"
    values = [each.value.VpcId]
  }
  filter {
    name   = "transit-gateway-id"
    values = [module.tgw_nonprod_region1.ec2_transit_gateway_id]
  }

  provider = aws.region1
}

data "aws_ec2_transit_gateway_vpc_attachment" "workloads_region2" {
  for_each = local.ipam_cidrs_region2

  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "vpc-id"
    values = [each.value.VpcId]
  }
  filter {
    name   = "transit-gateway-id"
    values = [module.tgw_nonprod_region2.ec2_transit_gateway_id]
  }

  provider = aws.region2
}

# Add a route to each specific Workload VPC to your Inspection TGW Route Table so Inspection VPC can send traffic back to Workload VPCs
resource "aws_ec2_transit_gateway_route" "workloads_region1" {
  for_each = local.ipam_cidrs_region1

  destination_cidr_block         = each.value.VpcCidr
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.workloads_region1[each.value.VpcId].id
  transit_gateway_route_table_id = module.tgw_rtb_inspection_region1.tgw_route_table_id
  provider                       = aws.region1
}

resource "aws_ec2_transit_gateway_route" "workloads_region2" {
  for_each = local.ipam_cidrs_region2

  destination_cidr_block         = each.value.VpcCidr
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_vpc_attachment.workloads_region2[each.value.VpcId].id
  transit_gateway_route_table_id = module.tgw_rtb_inspection_region2.tgw_route_table_id
  provider                       = aws.region2
}
