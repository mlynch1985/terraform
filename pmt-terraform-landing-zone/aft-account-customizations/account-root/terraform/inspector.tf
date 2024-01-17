# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_inspector2_delegated_admin_account" "region1" {
  for_each = {
    for account in data.aws_organizations_organization.this.accounts : account.id => account
    if account.name == "Audit"
  }
  account_id = each.value.id
  provider   = aws.region1
}

resource "aws_inspector2_delegated_admin_account" "region2" {
  for_each = {
    for account in data.aws_organizations_organization.this.accounts : account.id => account
    if account.name == "Audit"
  }
  account_id = each.value.id
  provider   = aws.region2
}
