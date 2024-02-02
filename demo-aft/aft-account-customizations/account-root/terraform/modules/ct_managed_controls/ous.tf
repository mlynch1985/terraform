# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}
data "aws_organizations_organization" "this" {}

data "aws_organizations_organizational_units" "level_one" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

data "aws_organizations_organizational_units" "level_two" {
  for_each  = local.level_one_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level_three" {
  for_each  = local.level_two_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level_four" {
  for_each  = local.level_three_ous
  parent_id = each.value.id
}

data "aws_organizations_organizational_units" "level_five" {
  for_each  = local.level_four_ous
  parent_id = each.value.id
}

locals {
  level_one_ous = { for ou in data.aws_organizations_organizational_units.level_one.children : ou.name => ou }

  level_two_ous = merge([
    for parent_name, ou in data.aws_organizations_organizational_units.level_two :
    { for child in ou.children : "${parent_name}/${child.name}" => child }
  ]...)

  level_three_ous = merge([
    for parent_name, ou in data.aws_organizations_organizational_units.level_three :
    { for child in ou.children : "${parent_name}/${child.name}" => child }
  ]...)

  level_four_ous = merge([
    for parent_name, ou in data.aws_organizations_organizational_units.level_four :
    { for child in ou.children : "${parent_name}/${child.name}" => child }
  ]...)

  level_five_ous = merge([
    for parent_name, ou in data.aws_organizations_organizational_units.level_five :
    { for child in ou.children : "${parent_name}/${child.name}" => child }
  ]...)

  all_ous = merge(local.level_one_ous, local.level_two_ous, local.level_three_ous, local.level_four_ous, local.level_five_ous)
}
