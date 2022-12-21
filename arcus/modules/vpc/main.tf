data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
}

resource "aws_default_route_table" "hub" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  tags = {
    "Name" = "default"
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "private" {
  count = length(var.az_zone_ids)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 2, count.index)
  availability_zone_id    = var.az_zone_ids[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "private_${count.index}",
    "tier" = "private"
  }
}

resource "aws_subnet" "transit" {
  count = length(var.az_zone_ids)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 2, count.index + length(var.az_zone_ids))
  availability_zone_id    = var.az_zone_ids[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "transit_${count.index}",
    "tier" = "transit"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "private",
    "tier" = "private"
  }
}

resource "aws_route_table" "transit" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "transit",
    "tier" = "transit"
  }
}

resource "aws_route" "private_default_tgw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.private.id
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

resource "aws_route" "transit_default_tgw" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.transit.id
  transit_gateway_id     = aws_ec2_transit_gateway.this.id
}

resource "aws_route_table_association" "private" {
  count = length(var.az_zone_ids)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "transit" {
  count = length(var.az_zone_ids)

  subnet_id      = aws_subnet.transit[count.index].id
  route_table_id = aws_route_table.transit.id
}

resource "aws_ec2_transit_gateway" "this" {
  auto_accept_shared_attachments = "enable"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = aws_subnet.transit[*].id
  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = aws_vpc.vpc.id
}
