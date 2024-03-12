# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  stack_name = "sechub_archive"
}

data "aws_iam_policy_document" "sechub_archive" {
  statement {
    sid       = "AllowEvents"
    actions   = ["events:PutEvents"]
    resources = ["arn:aws:events:${data.aws_region.current.name}:${local.log_archive_account_id}:event-bus/${local.stack_name}"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "StringEquals"
      variable = "events:source"
      values   = ["aws.securityhub"]
    }
    condition {
      test     = "StringEquals"
      variable = "events:detail-type"
      values   = ["Security Hub Findings - Imported"]
    }
  }
}

module "eventbridge_target_iam_role" {
  source = "../../modules/iam_role"

  role_name            = "${local.stack_name}_eventbridge"
  policy_description   = "Allow PutEvents to Log Archive account"
  role_description     = "IAM role with permissions to send events to log archive account event bus"
  max_session_duration = 3600
  path                 = "/aft/"
  policy_document      = data.aws_iam_policy_document.sechub_archive.json

  principals = [{ type = "Service", identifiers = ["events.amazonaws.com"] }]
}

resource "aws_cloudwatch_event_rule" "sechub_archive" {
  name        = "sechub_archive"
  description = "Stream all Security Hub Finding events to an Event bus in the Log Archive account"

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
  })
}

resource "aws_cloudwatch_event_target" "sechub_archive" {
  rule     = aws_cloudwatch_event_rule.sechub_archive.name
  arn      = "arn:aws:events:${data.aws_region.current.name}:${local.log_archive_account_id}:event-bus/sechub_archive"
  role_arn = module.eventbridge_target_iam_role.arn
}

resource "aws_cloudwatch_event_archive" "sechub_archive" {
  name             = local.stack_name
  description      = "Archive Security Hub Finding events for 90 days"
  event_source_arn = data.aws_cloudwatch_event_bus.default.arn
  retention_days   = 90

  event_pattern = jsonencode({
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
  })
}
