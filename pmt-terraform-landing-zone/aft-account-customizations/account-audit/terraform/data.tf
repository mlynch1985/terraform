# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {
  provider = aws.ct-management
}

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))

  log_archive_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.log_archive_account_name
  ][0]
}

data "aws_ssm_parameter" "account_s3_access_log_bucket_region1_arn" {
  name     = "/aft/account/account_s3_access_log_bucket_arn"
  provider = aws.region1
}

data "aws_ssm_parameter" "account_s3_access_log_bucket_region2_arn" {
  name     = "/aft/account/account_s3_access_log_bucket_arn"
  provider = aws.region2
}

data "aws_ssm_parameter" "account_s3_access_log_bucket_region3_arn" {
  name     = "/aft/account/account_s3_access_log_bucket_arn"
  provider = aws.region3
}
