resource "aws_vpc" "spoke" {
  ipv4_ipam_pool_id   = var.ipam_pool_id
  ipv4_netmask_length = var.ipam_pool_netmask

  tags = {
    "Name" = "spoke-vpc"
  }
}

resource "aws_default_network_acl" "spoke" {
  default_network_acl_id = aws_vpc.spoke.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    "Name" = "spoke-default"
  }
}

resource "aws_default_route_table" "spoke" {
  default_route_table_id = aws_vpc.spoke.default_route_table_id

  tags = {
    "Name" = "spoke-default"
  }
}

resource "aws_default_security_group" "spoke" {
  vpc_id = aws_vpc.spoke.id

  tags = {
    "Name" = "spoke-default"
  }
}

resource "aws_subnet" "spoke-private" {
  count = var.target_az_count

  vpc_id            = aws_vpc.spoke.id
  cidr_block        = cidrsubnet(aws_vpc.spoke.cidr_block, var.subnet_size_offset, count.index)
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = {
    "Name" = "spoke-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_subnet" "spoke-tgw" {
  count = var.target_az_count

  vpc_id            = aws_vpc.spoke.id
  cidr_block        = cidrsubnet(aws_vpc.spoke.cidr_block, var.subnet_size_offset, count.index + var.target_az_count)
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = {
    "Name" = "spoke-tgw-${local.az_index[count.index]}",
    "tier" = "tgw"
  }
}

resource "aws_route_table" "spoke-private" {
  count  = var.target_az_count
  vpc_id = aws_vpc.spoke.id

  tags = {
    "Name" = "spoke-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_route_table" "spoke-tgw" {
  count  = var.target_az_count
  vpc_id = aws_vpc.spoke.id

  tags = {
    "Name" = "spoke-tgw-${local.az_index[count.index]}",
    "tier" = "tgw"
  }
}

resource "aws_route_table_association" "spoke-private" {
  count = var.target_az_count

  subnet_id      = aws_subnet.spoke-private[count.index].id
  route_table_id = aws_route_table.spoke-private[count.index].id
}

resource "aws_route_table_association" "spoke-tgw" {
  count = var.target_az_count

  subnet_id      = aws_subnet.spoke-tgw[count.index].id
  route_table_id = aws_route_table.spoke-tgw[count.index].id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "spoke" {
  subnet_ids         = aws_subnet.spoke-tgw[*].id
  transit_gateway_id = var.tgw_id
  vpc_id             = aws_vpc.spoke.id

  tags = {
    "Name" = "spoke-attachment"
  }
}

resource "aws_route" "spoke-private-tgw" {
  count = var.target_az_count

  route_table_id         = aws_route_table.spoke-private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id
}

resource "aws_route" "spoke-tgw-tgw" {
  count = var.target_az_count

  route_table_id         = aws_route_table.spoke-tgw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.tgw_id
}
