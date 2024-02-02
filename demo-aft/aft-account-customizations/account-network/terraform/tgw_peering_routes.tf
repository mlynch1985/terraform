# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

#############################################
#####     DEV TGW Peer Route Tables     #####
#############################################

resource "aws_ec2_transit_gateway_route_table" "dev_peering_region1" {
  transit_gateway_id = module.tgw_dev_region1.ec2_transit_gateway_id

  tags = {
    Name   = "dev_peering_region1"
    Domain = "dev"
  }

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_route_table" "dev_peering_region2" {
  transit_gateway_id = module.tgw_dev_region2.ec2_transit_gateway_id

  tags = {
    Name   = "dev_peering_region2"
    Domain = "dev"
  }

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_route_table" "dev_peering_region3" {
  transit_gateway_id = module.tgw_dev_region3.ec2_transit_gateway_id

  tags = {
    Name   = "dev_peering_region3"
    Domain = "dev"
  }

  provider = aws.region3
}

#########################################################
#####     DEV TGW Peer Route Table Associations     #####
#########################################################

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region1_region2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region1.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region2_region1]
  provider   = aws.region1
}

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region1_region3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region1.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region3_region1]
  provider   = aws.region1
}

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region2_region1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region2.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region2_region1]
  provider   = aws.region2
}

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region2_region3" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region2_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region2.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region3_region2]
  provider   = aws.region2
}

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region3_region1" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region3.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region3_region1]
  provider   = aws.region3
}

resource "aws_ec2_transit_gateway_route_table_association" "dev_peering_region3_region2" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region2_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region3.id

  depends_on = [aws_ec2_transit_gateway_peering_attachment_accepter.dev_peering_region3_region2]
  provider   = aws.region3
}

###################################################
#####     DEV TGW Peer Route Table Routes     #####
###################################################

# Region 1
resource "aws_ec2_transit_gateway_route" "dev_peering_region1_local" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region1.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region1.id

  provider = aws.region1
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region1_region2" {
  destination_cidr_block         = local.region2_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region1.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region1_region2]
  provider   = aws.region1
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region1_region3" {
  destination_cidr_block         = local.region3_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region1.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region1_region3]
  provider   = aws.region1
}

# Region 2
resource "aws_ec2_transit_gateway_route" "dev_peering_region2_local" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region2.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region2.id

  provider = aws.region2
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region2_region1" {
  destination_cidr_block         = local.region1_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region2.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region2.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region2_region1]
  provider   = aws.region2
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region2_region3" {
  destination_cidr_block         = local.region3_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region2_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region2.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region2_region3]
  provider   = aws.region2
}

# Region 3
resource "aws_ec2_transit_gateway_route" "dev_peering_region3_local" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = module.dev_vpc_inspection_region3.tgw_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region3.id

  provider = aws.region3
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region3_region1" {
  destination_cidr_block         = local.region1_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region1_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region3.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region3_region1]
  provider   = aws.region3
}

resource "aws_ec2_transit_gateway_route" "dev_peering_region3_region2" {
  destination_cidr_block         = local.region2_pool
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.dev_peering_region2_region3.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dev_peering_region3.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.dev_peering_region3_region2]
  provider   = aws.region3
}
