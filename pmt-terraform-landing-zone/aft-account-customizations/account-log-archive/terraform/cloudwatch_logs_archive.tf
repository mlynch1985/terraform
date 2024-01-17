# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  log_stack_name = "cloudwatch_logs_archive"
}

data "aws_iam_policy_document" "cloudwatch_logs_archive_bucket_policy" {
  # allows cross account access from org principals only using a known firehose role name
  statement {
    sid = "AllowCrossAccountOrgAccess"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [module.cloudwatch_logs_archive_bucket.arn, "${module.cloudwatch_logs_archive_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:role/aft/${local.log_stack_name}_firehose*"]
    }
  }

  # baseline bucket policies
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [module.cloudwatch_logs_archive_bucket.arn, "${module.cloudwatch_logs_archive_bucket.arn}/*"]
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
    sid       = "RestrictToTLSRequestsOnly"
    effect    = "Deny"
    actions   = ["*"]
    resources = [module.cloudwatch_logs_archive_bucket.arn, "${module.cloudwatch_logs_archive_bucket.arn}/*"]
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
    resources = ["${module.cloudwatch_logs_archive_bucket.arn}/*"]
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

module "cloudwatch_logs_archive_bucket" {
  source = "../../modules/s3_bucket"

  bucket_name                      = replace(local.log_stack_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.cloudwatch_logs_archive_bucket_policy.json
  key_arn                          = module.cloudwatch_logs_archive_kms_key_region1.arn
  access_logs_key_arn              = module.cloudwatch_logs_archive_access_logs_kms_key.arn
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

module "cloudwatch_logs_archive_kms_key_region1" {
  source = "../../modules/kms_key"

  key_name            = "aft/${local.log_stack_name}"
  key_policy          = data.aws_iam_policy_document.cloudwatch_logs_archive_kms_key.json
  enable_multi_region = true

  providers = {
    aws = aws.region1
  }
}

module "cloudwatch_logs_archive_kms_key_replica_region2" {
  source = "../../modules/kms_key_replica"

  key_name        = "aft/${local.log_stack_name}"
  key_policy      = data.aws_iam_policy_document.cloudwatch_logs_archive_kms_key.json
  primary_key_arn = module.cloudwatch_logs_archive_kms_key_region1.arn

  providers = {
    aws = aws.region2
  }
}

data "aws_iam_policy_document" "cloudwatch_logs_archive_kms_key" {
  statement {
    sid = "Enable Firehose Roles to use this key"
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
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:role/aft/${local.log_stack_name}_firehose*"]
    }
  }

  statement {
    sid = "Allow Firehose Grants"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values = [
        "arn:aws:iam::*:role/AWSAFTExecution"
      ]
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
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
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

module "cloudwatch_logs_archive_access_logs_kms_key" {
  source = "../../modules/kms_key"

  key_name   = "aft/${local.log_stack_name}_access_logs"
  key_policy = data.aws_iam_policy_document.cloudwatch_logs_archive_access_logs_kms_key.json
}

data "aws_iam_policy_document" "cloudwatch_logs_archive_access_logs_kms_key" {
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

resource "aws_ssm_parameter" "cloudwatch_logs_archive_kms_key_region1_arn" {
  name  = "/aft/account/log-archive/cloudwatch_logs_archive_kms_key_region1_arn"
  type  = "SecureString"
  value = module.cloudwatch_logs_archive_kms_key_region1.arn

  provider = aws.aft-management
}

resource "aws_ssm_parameter" "cloudwatch_logs_archive_kms_key_replica_region2_arn" {
  name  = "/aft/account/log-archive/cloudwatch_logs_archive_kms_key_replica_region2_arn"
  type  = "SecureString"
  value = module.cloudwatch_logs_archive_kms_key_replica_region2.arn

  provider = aws.aft-management
}

resource "aws_ssm_parameter" "cloudwatch_logs_archive_bucket_arn" {
  name  = "/aft/account/log-archive/cloudwatch_logs_archive_bucket_arn"
  type  = "String"
  value = module.cloudwatch_logs_archive_bucket.arn

  provider = aws.aft-management
}
