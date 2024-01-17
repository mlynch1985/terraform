# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  stack_name = "sechub_archive"
}

resource "aws_cloudwatch_event_bus" "sechub_archive" {
  name = local.stack_name
}

data "aws_iam_policy_document" "bus_policy" {
  statement {
    sid       = "AuditAccountAccess"
    actions   = ["events:PutEvents"]
    resources = [aws_cloudwatch_event_bus.sechub_archive.arn]
    principals {
      type = "AWS"
      # A known predticable role name created in audit account
      identifiers = ["arn:aws:iam::${data.aws_ssm_parameter.audit_account_id.value}:role/aft/sechub_archive_eventbridge"]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}

resource "aws_cloudwatch_event_bus_policy" "sechub_archive" {
  policy         = data.aws_iam_policy_document.bus_policy.json
  event_bus_name = aws_cloudwatch_event_bus.sechub_archive.name
}

data "aws_iam_policy_document" "events_target" {
  statement {
    sid = "AllowFirehose"
    actions = [
      "firehose:PutRecord",
      "firehose:PutRecordBatch"
    ]
    resources = [aws_kinesis_firehose_delivery_stream.sechub_archive.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
  }
}

module "eventbridge_target_iam_role" {
  source = "../../modules/iam_role"

  role_name            = "${local.stack_name}_eventbridge"
  policy_description   = "Allow EventBridge write access to Firehose"
  role_description     = "IAM role to allow eventbridge target write permissions to Kinesis Firehose"
  max_session_duration = 3600
  path                 = "/aft/"
  principals           = [{ type = "Service", identifiers = ["events.amazonaws.com"] }]
  policy_document      = data.aws_iam_policy_document.events_target.json
}

resource "aws_cloudwatch_event_rule" "sechub_archive" {
  event_bus_name = aws_cloudwatch_event_bus.sechub_archive.name
  name           = local.stack_name
  description    = "Stream all Security Hub Finding events to Kinesis Firehose"
  event_pattern = jsonencode({
    account     = [nonsensitive(data.aws_ssm_parameter.audit_account_id.value)]
    source      = ["aws.securityhub"]
    detail-type = ["Security Hub Findings - Imported"]
  })
}

resource "aws_cloudwatch_event_target" "sechub_archive" {
  event_bus_name = aws_cloudwatch_event_bus.sechub_archive.name
  rule           = aws_cloudwatch_event_rule.sechub_archive.name
  arn            = aws_kinesis_firehose_delivery_stream.sechub_archive.arn
  role_arn       = module.eventbridge_target_iam_role.arn
}

resource "aws_cloudwatch_log_group" "sechub_archive" {
  name              = local.stack_name
  kms_key_id        = module.sechub_archive_kms_key.arn
  retention_in_days = 90
}

resource "aws_cloudwatch_log_stream" "sechub_archive" {
  name           = "S3Delivery"
  log_group_name = aws_cloudwatch_log_group.sechub_archive.name
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
      "s3:PutObject"
    ]
    resources = [
      module.sechub_archive_bucket.arn,
      "${module.sechub_archive_bucket.arn}/*"
    ]
  }
  statement {
    sid = "AllowKMS"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [module.sechub_archive_kms_key.arn]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["s3.${data.aws_region.current.name}.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${module.sechub_archive_bucket.arn}/*"]
    }
  }
  statement {
    sid       = "AllowLogs"
    actions   = ["logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.sechub_archive.arn}:*"]
  }
}

module "firehose_role" {
  source = "../../modules/iam_role"

  role_name            = "${local.stack_name}_firehose"
  policy_description   = "Allow write access to sechub archive S3 bucket"
  role_description     = "IAM role to allow firehose write permissions to sechub archive S3 bucket"
  max_session_duration = 3600
  path                 = "/aft/"
  principals           = [{ type = "Service", identifiers = ["firehose.amazonaws.com"] }]
  policy_document      = data.aws_iam_policy_document.firehose.json
}

resource "aws_kinesis_firehose_delivery_stream" "sechub_archive" {
  name        = local.stack_name
  destination = "extended_s3"

  server_side_encryption {
    enabled  = true
    key_type = "CUSTOMER_MANAGED_CMK"
    key_arn  = module.sechub_archive_kms_key.arn
  }

  extended_s3_configuration {
    role_arn           = module.firehose_role.arn
    bucket_arn         = module.sechub_archive_bucket.arn
    buffering_size     = 128
    buffering_interval = 60
    compression_format = "GZIP"
    kms_key_arn        = module.sechub_archive_kms_key.arn
    # https://docs.aws.amazon.com/firehose/latest/dev/s3-prefixes.html
    prefix              = "AWSLogs/!{partitionKeyFromQuery:account_id}/!{partitionKeyFromQuery:region}/!{partitionKeyFromQuery:source}/"
    error_output_prefix = "errors/!{timestamp:yyyy}/!{timestamp:MM}/!{timestamp:dd}/!{timestamp:HH}/!{firehose:error-output-type}/"

    dynamic_partitioning_configuration {
      enabled = true
    }

    processing_configuration {
      enabled = true

      processors {
        type = "MetadataExtraction"
        parameters {
          parameter_name  = "MetadataExtractionQuery"
          parameter_value = "{account_id:.detail.findings[].AwsAccountId,region:.detail.findings[].Region,source:.source}"
        }
        parameters {
          parameter_name  = "JsonParsingEngine"
          parameter_value = "JQ-1.6"
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = true
      log_stream_name = "S3Delivery"
      log_group_name  = local.stack_name
    }
  }
  depends_on = [
    module.sechub_archive_kms_key,
    module.firehose_role.aws_iam_role_policy_attachment,
    module.firehose_role.aws_iam_policy,
    module.firehose_role
  ]
}

module "sechub_archive_kms_key" {
  source = "../../modules/kms_key"

  key_name   = "aft/${local.stack_name}"
  key_policy = data.aws_iam_policy_document.sechub_archive_kms_key.json
}

data "aws_iam_policy_document" "sechub_archive_kms_key" {
  statement {
    sid = "Enable Specific Roles to use this key"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = [module.firehose_role.arn]
    }
  }
  statement {
    sid = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        # Update to reflect desired key administration role - Example: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/MyAdminRole
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html#cmk-permissions
    sid = "Enable CloudWatch Logs to use the key"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${local.stack_name}"]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}

module "sechub_archive_access_logs_kms_key" {
  source = "../../modules/kms_key"

  key_name   = "aft/${local.stack_name}_access_logs"
  key_policy = data.aws_iam_policy_document.sechub_archive_access_logs_kms_key.json
}

data "aws_iam_policy_document" "sechub_archive_access_logs_kms_key" {
  statement {
    sid = "Allow access for Key Administrators"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        # Update to reflect desired key administration role - Example: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/MyAdminRole
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    sid = "Enable S3 Access Logs to use the key"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}


data "aws_iam_policy_document" "sechub_archive_bucket_policy" {

  statement {
    sid = "AllowFirehoseAccess"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [
      module.sechub_archive_bucket.arn,
      "${module.sechub_archive_bucket.arn}/*",
    ]
    principals {
      type        = "AWS"
      identifiers = [module.firehose_role.arn]
    }
  }

  statement {
    sid     = "EnforceIdentityPerimeter"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      module.sechub_archive_bucket.arn,
      "${module.sechub_archive_bucket.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }

  statement {
    sid     = "RestrictToTLSRequestsOnly"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      module.sechub_archive_bucket.arn,
      "${module.sechub_archive_bucket.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid       = "DenyObjectsThatAreNotSSEKMS"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${module.sechub_archive_bucket.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = ["true"]
    }
  }
}

module "sechub_archive_bucket" {
  source = "../../modules/s3_bucket"

  bucket_name                      = replace(local.stack_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.sechub_archive_bucket_policy.json
  key_arn                          = module.sechub_archive_kms_key.arn
  access_logs_key_arn              = module.sechub_archive_access_logs_kms_key.arn
  enable_intelligent_archive_tiers = true

  lifecycle_rules = [{
    id                       = "default"
    status                   = "Enabled"
    expire_days              = 30
    noncurrent_days          = 30
    noncurrent_storage_class = "INTELLIGENT_TIERING"
    noncurrent_versions      = 1
    transition_days          = 15
    transition_storage_class = "INTELLIGENT_TIERING"
  }]
}
