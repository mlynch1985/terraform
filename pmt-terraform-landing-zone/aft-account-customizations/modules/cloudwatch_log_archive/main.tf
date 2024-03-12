# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

module "cw_logs_role" {
  source = "../../modules/iam_role"

  role_name            = replace("cloudwatch_logs_archive_logs_${data.aws_region.current.name}", "-", "_")
  policy_description   = "Allow write permission to Kinesis Firehose delivery stream"
  role_description     = "Role for CloudWatch Logs centralization using Kinesis Firehose"
  max_session_duration = 3600
  path                 = "/aft/"
  principals           = [{ type = "Service", identifiers = ["logs.amazonaws.com"] }]
  policy_document      = data.aws_iam_policy_document.logs.json
}

data "aws_iam_policy_document" "logs" {
  statement {
    sid = "AllowFirehose"
    actions = [
      "firehose:PutRecord"
    ]
    resources = [module.firehose.arn]
  }
}

resource "aws_cloudwatch_log_subscription_filter" "firehose" {
  for_each = toset(var.cw_log_group_names)

  name            = each.key
  role_arn        = module.cw_logs_role.arn
  log_group_name  = each.key
  destination_arn = module.firehose.arn
  filter_pattern  = ""

  depends_on = [
    module.cw_logs_role.aws_iam_role_policy_attachment
  ]
}

module "firehose_role" {
  source = "../../modules/iam_role"

  role_name            = replace("cloudwatch_logs_archive_firehose_${data.aws_region.current.name}", "-", "_")
  policy_description   = "Allow write access to cloudwatch logs archive S3 bucket"
  role_description     = "Role for Firehose cloudwatch logs centralization"
  max_session_duration = 3600
  path                 = "/aft/"
  principals           = [{ type = "Service", identifiers = ["firehose.amazonaws.com"] }]
  policy_document      = data.aws_iam_policy_document.firehose.json
}

# https://docs.aws.amazon.com/firehose/latest/dev/controlling-access.html#using-iam-s3
data "aws_iam_policy_document" "firehose" {

  statement {
    sid = "AllowS3"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      var.bucket_arn,
      "${var.bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/${data.aws_region.current.name}/*"
    ]
  }

  statement {
    sid = "AllowKMSUse"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [var.bucket_kms_key]
  }

  statement {
    sid = "AllowFirehoseKMS"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = [var.firehose_kms_key]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}

module "firehose" {
  source = "../../modules/cloudwatch_logs_firehose"

  name             = "cw-logs-archive-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  role_arn         = module.firehose_role.arn
  bucket_arn       = var.bucket_arn
  bucket_kms_key   = var.bucket_kms_key
  firehose_kms_key = var.firehose_kms_key

  depends_on = [module.firehose_role.aws_iam_role_policy_attachment]
}
