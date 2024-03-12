# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_macie2_organization_admin_account" "region1" {
  for_each = {
    for account in data.aws_organizations_organization.current.accounts : account.id => account
    if account.name == local.global_vars.audit_account_name
  }
  admin_account_id = each.value.id
  provider         = aws.region1
}

resource "aws_macie2_organization_admin_account" "region2" {
  for_each = {
    for account in data.aws_organizations_organization.current.accounts : account.id => account
    if account.name == local.global_vars.audit_account_name
  }
  admin_account_id = each.value.id
  provider         = aws.region2

  depends_on = [aws_detective_organization_admin_account.region1]
}

resource "aws_macie2_organization_admin_account" "region3" {
  for_each = {
    for account in data.aws_organizations_organization.current.accounts : account.id => account
    if account.name == local.global_vars.audit_account_name
  }
  admin_account_id = each.value.id
  provider         = aws.region3

  depends_on = [aws_detective_organization_admin_account.region2]
}

# resource "aws_macie2_organization_admin_account" "region4" {
#   for_each = {
#     for account in data.aws_organizations_organization.current.accounts : account.id => account
#     if account.name == local.global_vars.audit_account_name
#   }
#   admin_account_id = each.value.id
#   provider         = aws.region4

#   depends_on = [aws_detective_organization_admin_account.region3]
# }
