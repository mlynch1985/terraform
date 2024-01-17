# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  # Parse our the Firewall VPC Endpoints so we can match them to the correct AZ for our route table routes
  # Set the index (key value) to the AZ Name so we can map to a specific subnet
  fw_endpoints = { for value in aws_networkfirewall_firewall.this.firewall_status[0].sync_states : value.availability_zone => value.attachment[0].endpoint_id }
}

# Converts Zone IDs to Zone Names using the Zone ID as the Key and the Zone Name as the Value
data "aws_availability_zone" "current" {
  for_each = { for az in var.azs : az => az }
  zone_id  = each.value
}

resource "aws_route_table" "private" {
  for_each = { for az in var.azs : az => az }

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_private_${each.value}"
  }
}

resource "aws_route_table" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}_transit_${each.value}"
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
  route_table_id         = aws_route_table.private[each.value].id
  transit_gateway_id     = var.tgw_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.this]
}

resource "aws_route" "transit" {
  for_each = { for zone_id, zone_name in data.aws_availability_zone.current : zone_id => zone_name }

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.transit[each.key].id # Uses Zone ID as index to select correct route table
  vpc_endpoint_id        = local.fw_endpoints[each.value.name]  # Uses Zone Name as index to select correct FW Endpoint

  depends_on = [aws_networkfirewall_firewall.this]
}
