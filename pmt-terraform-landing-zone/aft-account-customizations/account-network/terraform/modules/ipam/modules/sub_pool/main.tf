# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc_ipam_pool" "sub" {
  address_family      = "ipv4"
  auto_import         = true
  ipam_scope_id       = var.ipam_scope_id
  source_ipam_pool_id = var.source_ipam_pool_id
  locale              = var.implied_locale != null ? var.implied_locale : var.pool_config.locale

  tags = {
    Name = var.pool_config.name
  }
}

resource "aws_vpc_ipam_pool_cidr" "sub" {
  for_each = toset(var.pool_config.cidr)

  ipam_pool_id = aws_vpc_ipam_pool.sub.id
  cidr         = each.value
}

resource "aws_ram_resource_share" "sub" {
  count = var.pool_config.ram_share_principals != null ? 1 : 0

  name = "ipam-${var.pool_config.name}-${var.implied_locale}"

  tags = {
    Name = "ipam-${var.pool_config.name}-${var.implied_locale}"
  }
}

resource "aws_ram_resource_association" "sub" {
  count = var.pool_config.ram_share_principals != null ? 1 : 0

  resource_arn       = aws_vpc_ipam_pool.sub.arn
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}

resource "aws_ram_principal_association" "sub" {
  for_each = var.pool_config.ram_share_principals != null ? { for principal in var.pool_config.ram_share_principals : principal => principal } : {}

  principal          = each.key
  resource_share_arn = aws_ram_resource_share.sub[0].arn
}
