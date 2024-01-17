# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "current" {}

data "aws_ssm_parameter" "audit_account_id" {
  name     = "/aft/account/audit/account-id"
  provider = aws.aft-management
}

data "aws_ssm_parameter" "aft_account_id" {
  name     = "/aft/account/aft-management/account-id"
  provider = aws.aft-management
}
