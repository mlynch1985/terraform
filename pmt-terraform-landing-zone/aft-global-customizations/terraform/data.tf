# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../${path.module}/global_vars.yaml")))

  ct_management_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.ct_management_account_name
  ][0]

  audit_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.audit_account_name
  ][0]
}

data "aws_caller_identity" "current" {}

data "aws_caller_identity" "ct-management" {
  provider = aws.ct-management
}

data "aws_organizations_organization" "current" {
  provider = aws.ct-management
}
