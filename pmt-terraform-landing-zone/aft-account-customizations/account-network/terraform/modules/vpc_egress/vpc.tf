# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc" "this" {
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = 24
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name   = var.name
    Type   = "Egress"
    Domain = var.domain
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
    Name   = "${var.name}_default"
    Type   = "Egress"
    Domain = var.domain
  }

  lifecycle {
    ignore_changes = [subnet_ids]
  }
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name   = "${var.name}-default"
    Type   = "Egress"
    Domain = var.domain
  }
}

# Assumes 3 AZs
resource "aws_subnet" "public" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(cidrsubnets(aws_vpc.this.cidr_block, 2, 2, 2, 4, 4, 4, 4), index(var.azs, each.value))
  availability_zone_id = each.value

  tags = {
    Name   = "${var.name}_public_${each.value}"
    Type   = "Egress"
    Tier   = "public"
    Domain = var.domain
  }
}

# Assumes 3 AZs
resource "aws_subnet" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(cidrsubnets(aws_vpc.this.cidr_block, 2, 2, 2, 4, 4, 4, 4), index(var.azs, each.value) + 3)
  availability_zone_id = each.value

  tags = {
    Name   = "${var.name}_transit_${each.value}"
    Type   = "Egress"
    Tier   = "transit"
    Domain = var.domain
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name   = var.name
    Type   = "Egress"
    Domain = var.domain
  }
}

resource "aws_eip" "this" {
  #checkov:skip=CKV2_AWS_19:Ensure that all EIP addresses allocated to a VPC are attached to EC2 instances :  These are attached to NAT Gateways
  for_each = { for az in var.azs : az => az }

  tags = {
    Name   = "${var.name}_${each.value}"
    Type   = "Egress"
    Domain = var.domain
  }
}

resource "aws_nat_gateway" "this" {
  for_each = { for az in var.azs : az => az }

  allocation_id = aws_eip.this[each.value].allocation_id
  subnet_id     = aws_subnet.public[each.value].id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name   = "${var.name}_${each.value}"
    Type   = "Egress"
    Domain = var.domain
  }
}
