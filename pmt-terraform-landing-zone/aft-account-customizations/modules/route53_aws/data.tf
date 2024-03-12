# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_caller_identity" "network" {
  provider = aws.network
}

data "aws_route53_zone" "parent" {
  name         = var.parent_domain_name
  private_zone = true
  provider     = aws.network
}

data "aws_vpc" "parent" {
  state = "available"

  tags = {
    Name   = var.parent_vpc_name
    Domain = var.domain
    Type   = "Shared_Services"
  }
  provider = aws.network
}

data "aws_route53_resolver_rules" "current" {
  owner_id     = data.aws_caller_identity.network.account_id
  rule_type    = "FORWARD"
  share_status = "SHARED_WITH_ME"
}
