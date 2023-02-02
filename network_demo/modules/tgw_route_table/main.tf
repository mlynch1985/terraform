resource "aws_ec2_transit_gateway_route_table" "this" {
  transit_gateway_id = var.tgw_id

  tags = {
    Name = var.rtb_name
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "this" {
  transit_gateway_attachment_id  = var.source_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route" "this" {
  for_each = var.routes

  destination_cidr_block         = each.value.cidr_block
  transit_gateway_attachment_id  = each.value.target_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.this.id
}
