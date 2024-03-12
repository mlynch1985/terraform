# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_organizations_organization" "current" {}

locals {
  audit_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == "Audit"
  ][0]
}

resource "aws_cloudformation_stack" "network" {
  #checkov:skip=CKV_AWS_124:Ensure that CloudFormation stacks are sending event notifications to an SNS topic
  name         = "StackSet-AWSControlTowerBP-BASELINE-CLOUDWATCH-created-via-aft"
  capabilities = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    EnableConfigRuleComplianceChangeAlarm = true
    LogsRetentionInDays                   = 14
    ManagedResourcePrefix                 = "aws-controltower"
    SecurityAccountId                     = local.audit_account_id
    SecurityTopicName                     = "aws-controltower-AggregateSecurityNotifications"
  }

  template_body = file("${path.module}/cfn_template.yml")
}
