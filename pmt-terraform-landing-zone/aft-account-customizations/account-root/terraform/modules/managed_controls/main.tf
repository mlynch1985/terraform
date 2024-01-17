# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}

data "aws_organizations_organization" "organization" {}

# Get OUs data resources up to five levels of OUs deep under a root (maximum nesting quota limit)
data "aws_organizations_organizational_units" "root" {
  parent_id = data.aws_organizations_organization.organization.roots[0].id
}

data "aws_organizations_organizational_units" "ous_depth_1" {
  for_each  = toset([for x in data.aws_organizations_organizational_units.root.children : x.id])
  parent_id = each.key
  depends_on = [
    data.aws_organizations_organizational_units.root
  ]
}

data "aws_organizations_organizational_units" "ous_depth_2" {
  for_each  = toset([for y in flatten([for x in data.aws_organizations_organizational_units.ous_depth_1 : x.children]) : y.id])
  parent_id = each.key
  depends_on = [
    data.aws_organizations_organizational_units.ous_depth_1
  ]
}

data "aws_organizations_organizational_units" "ous_depth_3" {
  for_each  = toset([for y in flatten([for x in data.aws_organizations_organizational_units.ous_depth_2 : x.children]) : y.id])
  parent_id = each.key
  depends_on = [
    data.aws_organizations_organizational_units.ous_depth_2
  ]
}

data "aws_organizations_organizational_units" "ous_depth_4" {
  for_each  = toset([for y in flatten([for x in data.aws_organizations_organizational_units.ous_depth_3 : x.children]) : y.id])
  parent_id = each.key
  depends_on = [
    data.aws_organizations_organizational_units.ous_depth_3
  ]
}

locals {
  # Extract Guardrails configuration
  guardrails_list = flatten([
    for i in range(0, length(var.controls)) : [
      for pair in setproduct(element(var.controls, i).control_names, element(var.controls, i).organizational_unit_ids) :
      { "arn:aws:controltower:${data.aws_region.current.name}::control/${pair[0]}" = pair[1] }
    ]
  ])

  ous_depth_1 = [for x in data.aws_organizations_organizational_units.root.children : x]
  ous_depth_2 = flatten([for x in data.aws_organizations_organizational_units.ous_depth_1 : x.children if length(x.children) != 0])
  ous_depth_3 = flatten([for x in data.aws_organizations_organizational_units.ous_depth_2 : x.children if length(x.children) != 0])
  ous_depth_4 = flatten([for x in data.aws_organizations_organizational_units.ous_depth_3 : x.children if length(x.children) != 0])
  ous_depth_5 = flatten([for x in data.aws_organizations_organizational_units.ous_depth_4 : x.children if length(x.children) != 0])

  # Compute map from OU id to OU arn for the whole organization
  ous_id_to_arn_map = { for ou in concat(local.ous_depth_1, local.ous_depth_2, local.ous_depth_3, local.ous_depth_4, local.ous_depth_5) :
    ou.id => ou.arn
  }
}

resource "aws_controltower_control" "guardrails" {
  for_each = { for control in local.guardrails_list : join(":", [keys(control)[0], values(control)[0]]) => [keys(control)[0], values(control)[0]] }

  control_identifier = each.value[0]
  target_identifier  = local.ous_id_to_arn_map[each.value[1]]
}
