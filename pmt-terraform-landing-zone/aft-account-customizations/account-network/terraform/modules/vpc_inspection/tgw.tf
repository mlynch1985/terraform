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
    Type   = "Inspection"
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
    Type   = "Inspection"
    Domain = var.domain
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.this.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}
