resource "aws_vpc" "hub" {
  ipv4_ipam_pool_id   = var.ipam_pool_id
  ipv4_netmask_length = var.ipam_pool_netmask

  tags = {
    "Name" = "hub-vpc"
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
  count = var.target_az_count

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, var.subnet_size_offset, count.index)
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = {
    "Name" = "hub-public-${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_subnet" "hub-private" {
  count = var.target_az_count

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, var.subnet_size_offset, count.index + var.target_az_count)
  availability_zone = data.aws_availability_zones.zones.names[count.index]

  tags = {
    "Name" = "hub-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_subnet" "hub-tgw" {
  count = var.target_az_count

  vpc_id            = aws_vpc.hub.id
  cidr_block        = cidrsubnet(aws_vpc.hub.cidr_block, var.subnet_size_offset, count.index + var.target_az_count + var.target_az_count)
  availability_zone = data.aws_availability_zones.zones.names[count.index]

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
  count  = var.target_az_count
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-private-${local.az_index[count.index]}",
    "tier" = "private"
  }
}

resource "aws_route_table" "hub-tgw" {
  count  = var.target_az_count
  vpc_id = aws_vpc.hub.id

  tags = {
    "Name" = "hub-tgw-${local.az_index[count.index]}",
    "tier" = "tgw"
  }
}

resource "aws_route_table_association" "hub-public" {
  count = var.target_az_count

  subnet_id      = aws_subnet.hub-public[count.index].id
  route_table_id = aws_route_table.hub-public.id
}

resource "aws_route_table_association" "hub-private" {
  count = var.target_az_count

  subnet_id      = aws_subnet.hub-private[count.index].id
  route_table_id = aws_route_table.hub-private[count.index].id
}

resource "aws_route_table_association" "hub-tgw" {
  count = var.target_az_count

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
  count = var.target_az_count

  tags = {
    "Name" = "hub-ngw-${local.az_index[count.index]}",
    "tier" = "public"
  }
}

resource "aws_nat_gateway" "hub-public" {
  count = var.target_az_count

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
  destination_cidr_block = var.tgw_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}

resource "aws_route" "hub-private-ngw" {
  count = var.target_az_count

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.hub-private[count.index].id
  nat_gateway_id         = aws_nat_gateway.hub-public[count.index].id
}

resource "aws_route" "hub-private-tgw" {
  count = var.target_az_count

  route_table_id         = aws_route_table.hub-private[count.index].id
  destination_cidr_block = var.tgw_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}

resource "aws_route" "hub-tgw-ngw" {
  count = var.target_az_count

  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.hub-tgw[count.index].id
  nat_gateway_id         = aws_nat_gateway.hub-public[count.index].id
}

resource "aws_route" "hub-tgw-tgw" {
  count = var.target_az_count

  route_table_id         = aws_route_table.hub-tgw[count.index].id
  destination_cidr_block = var.tgw_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.hub.id
}

resource "aws_ec2_transit_gateway_route" "hub-tgw-ngw" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway.hub.association_default_route_table_id
}
