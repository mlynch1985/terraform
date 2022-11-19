resource "aws_vpc" "hub" {
  ipv4_ipam_pool_id   = aws_vpc_ipam_pool.main.id
  ipv4_netmask_length = 16

  tags = {
    "Name" = "hub-vpc"
  }

  depends_on = [
    aws_vpc_ipam_pool_cidr.main
  ]
}

resource "aws_default_network_acl" "hub" {
  default_network_acl_id = aws_vpc.hub.default_network_acl_id

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
    "Name" = "hub-default"
  }
}

resource "aws_default_route_table" "hub" {
  default_route_table_id = aws_vpc.hub.default_route_table_id

  tags = {
    "Name" = "hub-default"
  }
}

resource "aws_default_security_group" "hub" {
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-default"
  }
}

resource "aws_subnet" "hub-public" {
  count = 4

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, 4, count.index)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "hub-public-${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_subnet" "hub-private" {
  count = 4

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, 4, count.index + 4)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "hub-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_subnet" "hub-tgw" {
  count = 4

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, 4, count.index + 8)
  availability_zone = data.aws_availability_zones.zones.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    "Name" = "hub-tgw-${local.az_index[count.index]}",
    "tier" = "tgw"
  }
}

resource "aws_route_table" "hub-public" {
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-public",
    "tier" = "public"
  }
}

resource "aws_route_table" "hub-private" {
  count  = 4
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_route_table" "hub-tgw" {
  count  = 4
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-tgw-${local.az_index[count.index]}",
    "tier" = "tgw"
  }
}

resource "aws_route_table_association" "hub-public" {
  count = 4

  subnet_id      = aws_subnet.hub-public[count.index].id
  route_table_id = aws_route_table.hub-public.id
}

resource "aws_route_table_association" "hub-private" {
  count = 4

  subnet_id      = aws_subnet.hub-private[count.index].id
  route_table_id = aws_route_table.hub-private[count.index].id
}

resource "aws_route_table_association" "hub-tgw" {
  count = 4

  subnet_id      = aws_subnet.hub-tgw[count.index].id
  route_table_id = aws_route_table.hub-tgw[count.index].id
}

resource "aws_internet_gateway" "hub-igw" {
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-igw"
  }
}

resource "aws_eip" "hub-ngw" {
  #checkov:skip=CKV2_AWS_19:We are intentionally not assigning these to EC2 Instances but rather NAT Gateways as part of this demo
  count = 4

  tags = {
    "Name" = "hub-ngw-${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_nat_gateway" "hub-public" {
  count = 4

  allocation_id = aws_eip.hub-ngw[count.index].id
  subnet_id     = aws_subnet.hub-public[count.index].id

  tags = {
    "Name" = "hub-public-${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_ec2_transit_gateway" "hub" {
  auto_accept_shared_attachments = "enable"

  tags = {
    "Name" = "hub-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  subnet_ids         = aws_subnet.hub-tgw[*].id
  transit_gateway_id = aws_ec2_transit_gateway.hub.id
  vpc_id             = aws_vpc.hub.id

  tags = {
    "Name" = "hub-attachment"
  }
}

resource "aws_route" "hub-public-default" {
  route_table_id         = aws_route_table.hub-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.hub-igw.id
}

resource "aws_route" "hub-public-tgw" {
  route_table_id         = aws_route_table.hub-public.id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}

resource "aws_route" "hub-private-ngw" {
  count = 4

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.hub-private[count.index].id
  nat_gateway_id         = aws_nat_gateway.hub-public[count.index].id
}

resource "aws_route" "hub-private-tgw" {
  count = 4

  route_table_id         = aws_route_table.hub-private[count.index].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}

resource "aws_route" "hub-tgw-ngw" {
  count = 4

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.hub-tgw[count.index].id
  nat_gateway_id         = aws_nat_gateway.hub-public[count.index].id
}

resource "aws_route" "hub-tgw-tgw" {
  count = 4

  route_table_id         = aws_route_table.hub-tgw[count.index].id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}
