# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_vpc_ipam_organization_admin_account" "global" {
  for_each = {
    for account in data.aws_organizations_organization.current.accounts : account.id => account
    if account.name == local.global_vars.network_account_name
  }
  delegated_admin_account_id = each.value.id
}
