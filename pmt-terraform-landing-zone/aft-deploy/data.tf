# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}
data "aws_caller_identity" "aft-management" {
  provider = aws.aft-management
}

data "aws_organizations_organization" "current" {}

locals {
  ct_home_region      = "us-east-1"
  ct_secondary_region = "us-east-2"
  branch_name         = "main"

  ct_management_account_id = [for account in data.aws_organizations_organization.current.accounts : account.id
  if account.name == "CT-Management"][0]

  aft_management_account_id = [for account in data.aws_organizations_organization.current.accounts : account.id
  if account.name == "AFT-Management"][0]

  audit_account_id = [for account in data.aws_organizations_organization.current.accounts : account.id
  if account.name == "Audit"][0]

  log_archive_account_id = [for account in data.aws_organizations_organization.current.accounts : account.id
  if account.name == "Log Archive"][0]
}
