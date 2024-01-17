# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc" "this" {
  ipv4_ipam_pool_id    = var.ipam_pool_id
  ipv4_netmask_length  = 21
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name                  = "${var.name}-${data.aws_caller_identity.current.account_id}"
    Type                  = "workload"
    TGW_Route_Auto_Enable = var.auto_enable_tgw_route
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

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-default"
  }
}

resource "aws_subnet" "private" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = cidrsubnet(aws_vpc.this.cidr_block, ceil(length(var.azs) / 2) + 1, index(var.azs, each.value))
  availability_zone_id = each.value

  tags = {
    Name = "${var.name}_private_${each.value}"
  }
}

resource "aws_subnet" "transit" {
  for_each = { for az in var.azs : az => az }

  vpc_id               = aws_vpc.this.id
  cidr_block           = cidrsubnet(aws_vpc.this.cidr_block, ceil(length(var.azs) / 2) + 1, index(var.azs, each.value) + length(var.azs))
  availability_zone_id = each.value

  tags = {
    Name = "${var.name}_transit_${each.value}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  appliance_mode_support                          = "enable"
  subnet_ids                                      = [for subnet in aws_subnet.transit : subnet.id]
  transit_gateway_id                              = data.aws_ec2_transit_gateway.this.id
  vpc_id                                          = aws_vpc.this.id
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = false

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
