# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.tgw_id

  tags = {
    Name = var.rtb_name
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = var.source_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
  replace_existing_association   = true
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = var.routes

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.target_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id

  depends_on = [aws_ec2_transit_gateway_route_table_association.this]
}
