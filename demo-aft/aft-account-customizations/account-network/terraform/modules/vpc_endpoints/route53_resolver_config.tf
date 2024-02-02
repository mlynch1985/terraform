# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_route53_resolver_endpoint" "inbound" {
  direction          = "INBOUND"
  security_group_ids = [aws_security_group.route53_resolver_inbound.id]

  dynamic "ip_address" {
    for_each = { for subnet_id in var.subnet_ids : subnet_id => subnet_id }

    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Domain = var.domain
  }
}

resource "aws_route53_resolver_endpoint" "outbound" {
  direction          = "OUTBOUND"
  security_group_ids = [aws_security_group.route53_resolver_outbound.id]

  dynamic "ip_address" {
    for_each = { for subnet_id in var.subnet_ids : subnet_id => subnet_id }

    content {
      subnet_id = ip_address.value
    }
  }

  tags = {
    Domain = var.domain
  }
}

resource "aws_route53_resolver_rule" "this" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint => endpoint }

  domain_name          = "${each.value}.${data.aws_region.current.name}.amazonaws.com"
  name                 = "vpce-${each.value}"
  rule_type            = "FORWARD"
  resolver_endpoint_id = aws_route53_resolver_endpoint.outbound.id

  dynamic "target_ip" {
    for_each = aws_route53_resolver_endpoint.inbound.ip_address

    content {
      ip = target_ip.value["ip"]
    }
  }
}

resource "aws_ram_resource_share" "this" {
  name                      = "vpce-resolver-rules-${var.domain}"
  allow_external_principals = false

  tags = {
    Domain = var.domain
  }
}

resource "aws_ram_resource_association" "this" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint => endpoint }

  resource_arn       = aws_route53_resolver_rule.this[each.value].arn
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_principal_association" "this" {
  for_each = var.ram_share_principals != [] ? { for principal in var.ram_share_principals : principal => principal } : {}

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
