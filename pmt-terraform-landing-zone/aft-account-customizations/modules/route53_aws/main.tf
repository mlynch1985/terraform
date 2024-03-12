# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route53_resolver_rule_association" "this" {
  for_each = toset(data.aws_route53_resolver_rules.current.resolver_rule_ids)

  resolver_rule_id = each.value
  vpc_id           = var.account_vpc_id
}

resource "aws_route53_vpc_association_authorization" "parent_to_account" {
  vpc_id   = var.account_vpc_id
  zone_id  = data.aws_route53_zone.parent.zone_id
  provider = aws.network
}

resource "aws_route53_zone_association" "parent_to_account" {
  vpc_id  = aws_route53_vpc_association_authorization.parent_to_account.vpc_id
  zone_id = aws_route53_vpc_association_authorization.parent_to_account.zone_id
}

resource "aws_route53_vpc_association_authorization" "account_to_parent" {
  vpc_id  = data.aws_vpc.parent.id
  zone_id = var.account_zone_id
}

resource "aws_route53_zone_association" "account_to_parent" {
  vpc_id   = aws_route53_vpc_association_authorization.account_to_parent.vpc_id
  zone_id  = aws_route53_vpc_association_authorization.account_to_parent.zone_id
  provider = aws.network
}
