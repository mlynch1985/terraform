# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  name = "SecurityNotifications"
}

module "securitynotification_sns_region1" {
  source = "../../modules/sns"

  name              = local.name
  display_name      = local.name
  kms_master_key_id = module.sns_kms_key_region1.id
  tracing_config    = "Active"

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    s3 = {
      sid    = "AllowSNSS3BucketNotification"
      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      principals = [{
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
      }]
      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values = [
          module.cloudwatch_logs_archive_bucket.arn,
          module.cloudwatch_logs_archive_replica_bucket.arn,
          module.sechub_archive_bucket.arn
        ]
      }]
    }
    eb = {
      sid     = "AllowSNSEventBridgeNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }
    cwe = {
      sid     = "AllowSNSCloudWatchNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["cloudwatch.amazonaws.com"]
      }]
    }
  }

  providers = {
    aws = aws.region1
  }
}

module "securitynotification_sns_region2" {
  source = "../../modules/sns"

  name              = local.name
  display_name      = local.name
  kms_master_key_id = module.sns_kms_key_region2.id
  tracing_config    = "Active"

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    s3 = {
      sid    = "AllowSNSS3BucketNotification"
      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      principals = [{
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
      }]
      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values = [
          module.cloudwatch_logs_archive_bucket.arn,
          module.cloudwatch_logs_archive_replica_bucket.arn,
          module.sechub_archive_bucket.arn,
          module.sechub_archive_replica_bucket.arn
        ]
      }]
    }
    eb = {
      sid     = "AllowSNSEventBridgeNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }
    cwe = {
      sid     = "AllowSNSCloudWatchNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["cloudwatch.amazonaws.com"]
      }]
    }
  }

  providers = {
    aws = aws.region2
  }
}

module "securitynotification_sns_region3" {
  source = "../../modules/sns"

  name              = local.name
  display_name      = local.name
  kms_master_key_id = module.sns_kms_key_region3.id
  tracing_config    = "Active"

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    s3 = {
      sid    = "AllowSNSS3BucketNotification"
      effect = "Allow"
      actions = [
        "sns:Publish",
      ]
      principals = [{
        type        = "Service"
        identifiers = ["s3.amazonaws.com"]
      }]
      conditions = [{
        test     = "ArnEquals"
        variable = "aws:SourceArn"
        values = [
          module.cloudwatch_logs_archive_bucket.arn,
          module.cloudwatch_logs_archive_replica_bucket.arn,
          module.sechub_archive_bucket.arn
        ]
      }]
    }
    eb = {
      sid     = "AllowSNSEventBridgeNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }
    cwe = {
      sid     = "AllowSNSCloudWatchNotification"
      effect  = "Allow",
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["cloudwatch.amazonaws.com"]
      }]
    }
  }

  providers = {
    aws = aws.region3
  }
}

module "sns_kms_key_region1" {
  source = "../../modules/kms_key"

  key_name   = "sns/${local.name}"
  key_policy = data.aws_iam_policy_document.sns_kms_key.json

  providers = {
    aws = aws.region1
  }
}

module "sns_kms_key_region2" {
  source = "../../modules/kms_key"

  key_name   = "sns/${local.name}"
  key_policy = data.aws_iam_policy_document.sns_kms_key.json

  providers = {
    aws = aws.region2
  }
}

module "sns_kms_key_region3" {
  source = "../../modules/kms_key"

  key_name   = "sns/${local.name}"
  key_policy = data.aws_iam_policy_document.sns_kms_key.json

  providers = {
    aws = aws.region3
  }
}


data "aws_iam_policy_document" "sns_kms_key" {
  #checkov:skip=CKV_AWS_109:Condition is restricting to accounts only within the organizations or aws service principal.
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.

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
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    sid = "Enable SNS to use the key"
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
      identifiers = ["sns.amazonaws.com"]
    }
  }
  statement {
    sid = "Enable CW to use the key"
    actions = [
      "kms:Decrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
  statement {
    sid = "Enable S3 to use the key"
    actions = [
      "kms:Decrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
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
