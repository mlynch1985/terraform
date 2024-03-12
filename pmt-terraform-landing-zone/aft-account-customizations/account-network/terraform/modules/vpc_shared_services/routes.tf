# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route_table" "private" {
  for_each = { for az in var.azs : az => az }

  vpc_id = aws_vpc.this.id

  tags = {
    Name   = "${var.name}_private_${each.value}"
    Type   = "Shared_Services"
    Tier   = "private"
    Domain = var.domain
  }
}

resource "aws_route_table" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id = aws_vpc.this.id

  tags = {
    Name   = "${var.name}_transit_${each.value}"
    Type   = "Shared_Services"
    Tier   = "transit"
    Domain = var.domain
  }
}

resource "aws_route_table_association" "private" {
  for_each = { for az in var.azs : az => az }

  subnet_id      = aws_subnet.private[each.value].id
  route_table_id = aws_route_table.private[each.value].id
}

resource "aws_route_table_association" "transit" {
  for_each = { for az in var.azs : az => az }

  subnet_id      = aws_subnet.transit[each.value].id
  route_table_id = aws_route_table.transit[each.value].id
}

resource "aws_route" "private" {
  for_each = { for az in var.azs : az => az }

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private[each.key].id
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_route" "transit" {
  for_each = { for az in var.azs : az => az }

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.transit[each.value].id
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
