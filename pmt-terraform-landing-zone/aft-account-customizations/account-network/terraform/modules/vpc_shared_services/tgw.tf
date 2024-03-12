# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [for subnet in aws_subnet.transit : subnet.id]
  transit_gateway_id                              = var.tgw_id
  vpc_id                                          = aws_vpc.this.id
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  tags = {
    Name   = var.name
    Type   = "Shared Services"
    Domain = var.domain
  }

  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.tgw_id

  tags = {
    Name   = var.name
    Type   = "Shared Services"
    Domain = var.domain
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route" "default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = var.tgw_default_route_attachment_id # Inspection VPC or OnPrem network
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.this]
}

resource "aws_ec2_transit_gateway_route" "inspection" {
  destination_cidr_block         = aws_vpc.this.cidr_block
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = var.tgw_inspection_tbl_id

  depends_on = [aws_ec2_transit_gateway_route.default]
}
