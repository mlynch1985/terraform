# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc" "this" {
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = 20
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name   = var.name
    Type   = "Shared_Services"
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
    Type   = "Shared_Services"
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
    Type   = "Shared_Services"
    Domain = var.domain
  }
}

# Assumes 3 AZs
resource "aws_subnet" "private" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(cidrsubnets(aws_vpc.this.cidr_block, 2, 2, 2, 5, 5, 5, 3), index(var.azs, each.value))
  availability_zone_id = each.value

  tags = {
    Name   = "${var.name}_private_${each.value}"
    Type   = "Shared_Services"
    Tier   = "private"
    Domain = var.domain
  }
}

# Assumes 3 AZs
resource "aws_subnet" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = element(cidrsubnets(aws_vpc.this.cidr_block, 2, 2, 2, 5, 5, 5, 3), index(var.azs, each.value) + 3)
  availability_zone_id = each.value

  tags = {
    Name   = "${var.name}_transit_${each.value}"
    Type   = "Shared_Services"
    Tier   = "transit"
    Domain = var.domain
  }
}
