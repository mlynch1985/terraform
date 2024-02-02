# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# "This operation must be performed in the us-east-1 region." https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/fms_admin_account
resource "aws_fms_admin_account" "this" {
  for_each = {
    for account in data.aws_organizations_organization.this.accounts : account.id => account
    if account.name == local.global_vars.audit_account_name
  }
  account_id = each.value.id
  provider   = aws.use1 # Must use a us-east-1 provider and CT must have us-east-1 enabled
}
