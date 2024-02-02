# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_security_group" "route53_resolver_inbound" {
  #checkov:skip=CKV2_AWS_5:Attached to Route53 Resolvers, this is false positive
  name_prefix = "route53_inbound_resolvers_"
  description = "Enables DNS Resolution from AWS Network"
  vpc_id      = var.vpc_id

  ingress {
    description = "TCP DNS from Private VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = var.sg_inbound_source_cidrs
  }

  ingress {
    description = "UDP DNS from Private VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = var.sg_inbound_source_cidrs
  }

  egress {
    description = "Allow All TCP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All UDP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "route53_inbound_resolvers_${var.domain}"
    Domain = var.domain
  }
}

resource "aws_security_group" "route53_resolver_outbound" {
  #checkov:skip=CKV2_AWS_5:Attached to Route53 Resolvers, this is false positive
  name_prefix = "route53_outbound_resolvers_"
  description = "Enables DNS Resolution from AWS Network"
  vpc_id      = var.vpc_id

  ingress {
    description = "TCP DNS from Private VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = var.sg_outbound_source_cidrs
  }

  ingress {
    description = "UDP DNS from Private VPCs"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = var.sg_outbound_source_cidrs
  }

  egress {
    description = "Allow All TCP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All UDP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "route53_outbound_resolvers_${var.domain}"
    Domain = var.domain
  }
}

resource "aws_security_group" "vpce_endpoints" {
  #checkov:skip=CKV2_AWS_5:Attached to VPC Endpoints, this is false positive
  name_prefix = "vpc_endpoints_"
  description = "Enables HTTPS Access to VPC Endpoints from AWS Network"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS from Private VPCs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.sg_inbound_source_cidrs
  }

  egress {
    description = "Allow All TCP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All UDP 53 Outbound"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow All TCP 443 Outbound"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "vpc_endpoints_${var.domain}"
    Domain = var.domain
  }
}
