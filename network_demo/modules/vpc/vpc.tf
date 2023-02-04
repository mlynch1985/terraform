resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = var.name
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id

  ingress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 11
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 10
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 11
    action     = "deny"
    cidr_block = "0.0.0.0/0"
    from_port  = 3389
    to_port    = 3389
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
    Name = "${var.name}_default"
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "this" {
  count = length(var.secondary_cidr_blocks) > 0 ? length(var.secondary_cidr_blocks) : 0

  vpc_id     = aws_vpc.this.id
  cidr_block = element(var.secondary_cidr_blocks, count.index)
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-default"
  }
}

resource "aws_internet_gateway" "this" {
  count = var.enable_internet_gateway && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.public_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.public_subnet_names, [""]), count.index)
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.private_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.private_subnet_names, [""]), count.index)
  }
}

resource "aws_subnet" "transit" {
  count = length(var.transit_subnets) > 0 ? length(var.transit_subnets) : 0

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(concat(var.transit_subnets, [""]), count.index)
  availability_zone_id = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = element(concat(var.transit_subnet_names, [""]), count.index)
  }
}

resource "aws_eip" "this" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc = true
}

resource "aws_nat_gateway" "this" {
  count = var.enable_nat_gateway && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  allocation_id = element(aws_eip.this[*].id, count.index)
  subnet_id     = element(aws_subnet.public[*].id, count.index)

  depends_on = [aws_internet_gateway.this]
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  subnet_ids             = aws_subnet.transit[*].id
  transit_gateway_id     = var.tgw_id
  vpc_id                 = aws_vpc.this.id
  appliance_mode_support = var.appliance_mode_support

  tags = {
    Name = var.name
  }

  lifecycle {
    ignore_changes = [
      transit_gateway_default_route_table_association,
      transit_gateway_default_route_table_propagation
    ]
  }
}
