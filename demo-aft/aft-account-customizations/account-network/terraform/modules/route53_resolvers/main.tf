# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Create VPC Security Groups for our Route53 Inbound/Outbound Resolvers
resource "aws_security_group" "this" {
  name        = "${var.domain}_route53_resolvers"
  description = "Allow DNS query traffic from AWS network"
  vpc_id      = var.endpoints_vpc.vpc_id

  tags = {
    Name   = "${var.domain}_route53_resolvers"
    Domain = var.domain
  }
}

# Create TCP/UDP rules for DNS port 53
resource "aws_vpc_security_group_ingress_rule" "tcp" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_ip_range
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "udp" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_ip_range
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
}

resource "aws_vpc_security_group_egress_rule" "tcp" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_ip_range
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "udp" {
  security_group_id = aws_security_group.this.id
  cidr_ipv4         = var.allowed_ip_range
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
}

# Create Route53 Inbound Resolvers to recieve DNS queries
resource "aws_route53_resolver_endpoint" "inbound" {
  name               = replace("${var.domain}_inbound_resolver", ".", "_")
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.this.id]

  dynamic "ip_address" {
    for_each = var.endpoints_vpc.private_subnets
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name   = replace("${var.domain}_inbound_resolver", ".", "_")
    Domain = var.domain
  }
}

# Create Route53 Outbound Resolvers to forward queries
resource "aws_route53_resolver_endpoint" "outbound" {
  name               = replace("${var.domain}_outbound_resolver", ".", "_")
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.this.id]

  dynamic "ip_address" {
    for_each = var.endpoints_vpc.private_subnets
    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Name   = replace("${var.domain}_outbound_resolver", ".", "_")
    Domain = var.domain
  }
}

# Create Route53 Forwarding Rules
resource "aws_route53_resolver_rule" "this" {
  domain_name          = var.domain
  name                 = replace(var.domain, ".", "_")
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = var.onprem_ips
    content {
      ip = target_ip.value
    }
  }

  tags = {
    Name   = "${var.domain}_resolver"
    Domain = var.domain
  }
}

resource "aws_ram_resource_share" "this" {
  name                      = replace(var.domain, ".", "_")
  allow_external_principals = false

  tags = {
    Name   = replace(var.domain, ".", "_")
    Domain = var.domain
  }
}

resource "aws_ram_resource_association" "this" {
  resource_arn       = aws_route53_resolver_rule.this.arn
  resource_share_arn = aws_ram_resource_share.this.id
}

resource "aws_ram_principal_association" "this" {
  count = length(var.ram_principals)

  principal          = var.ram_principals[count.index]
  resource_share_arn = aws_ram_resource_share.this.arn
}
