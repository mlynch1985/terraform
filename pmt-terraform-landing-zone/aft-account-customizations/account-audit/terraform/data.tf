# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  account_list = jsondecode(file("account_list.json"))
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_organizations_organization" "current" {}

data "aws_cloudwatch_event_bus" "default" {
  name = "default"
}

data "aws_ssm_parameter" "log_archive_account_id" {
  name     = "/aft/account/log-archive/account-id"
  provider = aws.aft-management
}
