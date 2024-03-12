# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc_endpoint" "this" {
  for_each = { for endpoint in var.vpc_endpoints : endpoint => endpoint }

  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_id              = var.vpc_id
  private_dns_enabled = false
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.vpce_endpoints.id]
  vpc_endpoint_type   = "Interface"

  tags = {
    Name   = each.value
    Domain = var.domain
  }
}
