# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route53_zone" "aws_private" {
  for_each = toset(local.global_vars.route53_aws_private_domains)

  name          = each.value
  force_destroy = true # Used for testing, set to false for production environments

  # Used inline VPC association to force this zone to be private
  vpc {
    vpc_id = module.dev_vpc_shared_services_region1.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "aws_private_region2" {
  for_each = toset(local.global_vars.route53_aws_private_domains)

  zone_id  = aws_route53_zone.aws_private[each.value].zone_id
  vpc_id   = module.dev_vpc_shared_services_region2.vpc_id
  provider = aws.region2
}

resource "aws_route53_zone_association" "aws_private_region3" {
  for_each = toset(local.global_vars.route53_aws_private_domains)

  zone_id  = aws_route53_zone.aws_private[each.value].zone_id
  vpc_id   = module.dev_vpc_shared_services_region3.vpc_id
  provider = aws.region3
}

resource "aws_route53_record" "aws_test_records" {
  for_each = toset(local.global_vars.route53_aws_private_domains)

  zone_id = aws_route53_zone.aws_private[each.value].zone_id
  name    = "test.${each.value}"
  type    = "A"
  ttl     = "300"
  records = ["1.1.1.1"]
}
