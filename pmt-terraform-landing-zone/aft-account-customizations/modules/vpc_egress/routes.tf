# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_public"
  }
}

resource "aws_route_table" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_transit_${each.value}"
  }
}

resource "aws_route_table_association" "public" {
  for_each = { for az in var.azs : az => az }

  subnet_id      = aws_subnet.public[each.value].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "transit" {
  for_each = { for az in var.azs : az => az }

  subnet_id      = aws_subnet.transit[each.value].id
  route_table_id = aws_route_table.transit[each.value].id
}

resource "aws_route" "public_igw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route" "public_tgw" {
  destination_cidr_block = var.tgw_cidr_route
  route_table_id         = aws_route_table.public.id
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_route" "transit_ngw" {
  for_each = { for az in var.azs : az => az }

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.transit[each.value].id
  nat_gateway_id         = aws_nat_gateway.this[each.value].id
}

resource "aws_route" "transit_tgw" {
  for_each = { for az in var.azs : az => az }

  destination_cidr_block = var.tgw_cidr_route
  route_table_id         = aws_route_table.transit[each.value].id
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}
