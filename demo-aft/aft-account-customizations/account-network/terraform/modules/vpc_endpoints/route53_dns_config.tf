# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route53_zone" "this" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint => endpoint }

  name          = "${each.value}.${data.aws_region.current.name}.amazonaws.com"
  comment       = "${var.domain} ${each.value} VPC Endpoint"
  force_destroy = true

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name   = each.value
    Domain = var.domain
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_record" "this" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint => endpoint }

  name    = "${each.value}.${data.aws_region.current.name}.amazonaws.com"
  zone_id = aws_route53_zone.this[each.value].zone_id
  type    = "A"

  alias {
    name                   = aws_vpc_endpoint.this[each.key].dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.this[each.key].dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }
}
