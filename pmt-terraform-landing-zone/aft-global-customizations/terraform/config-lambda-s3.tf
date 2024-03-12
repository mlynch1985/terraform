# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  config_bucket_name         = "config-lambda-src"
  config_bucket_replica_name = "config-lambda-src-r"
}

module "config_lambda_src_bucket" {
  #checkov:skip=CKV_AWS_300:Lifecycle rule is set but checkov is producing false positive
  source = "./modules/s3_bucket"

  bucket_name                      = replace(local.config_bucket_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.config_lambda_src_bucket_policy.json
  key_arn                          = module.config_lambda_src_kms_key_region1.arn
  access_log_bucket_arn            = module.account_s3_access_log_bucket_region1.arn
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

  replication_configuration = {
    role = aws_iam_role.replication.arn

    rules = [
      {
        id                        = "replicate-all-objects"
        status                    = "Enabled"
        delete_marker_replication = false

        source_selection_criteria = {
          sse_kms_encrypted_objects = {
            enabled = true
          }
        }

        destination = {
          bucket             = module.config_lambda_src_replica_bucket.arn
          storage_class      = "INTELLIGENT_TIERING"
          replica_kms_key_id = module.config_lambda_src_kms_key_replica_region2.arn

          replication_time = {
            status  = "Enabled"
            minutes = 15
          }

          metrics = {
            status  = "Enabled"
            minutes = 15
          }
        }
      }
    ]
  }

  sns_notifications = {
    security_sns = {
      topic_arn = module.securitynotification_sns_region1.topic_arn
      events    = ["s3:ObjectRemoved:Delete"]
    }
  }

  # S3-3  - Skipping OPA check for s3 default KMS check as it is a false positive
  # S3-7  - Skipping OPA check for s3 KMS encryption check as it is a false positive
  # S3-9  - Skipping OPA check for s3 logging check as it is a false positive
  # S3-10 - Skipping OPA check for ls3 loggin check check as it is a false positive
  # S3-12 - Skipping OPA check for lifecycle policy check as it is a false positive
  # S3-15 - Skipping OPA check for object lock s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-3/S3-7/S3-9/S3-10/S3-12/S3-15"
  }
}

module "config_lambda_src_replica_bucket" {
  #checkov:skip=CKV_AWS_300:Lifecycle rule is set but checkov is producing false positive
  #checkov:skip=CKV2_AWS_62:notification is set but checkov is producing false positive
  #checkov:skip=CKV2_AWS_62:notification is set but checkov is producing false positive
  #checkov:skip=CKV_AWS_144:This is a destination bucket for replica. No need to create replica of replica.
  source = "./modules/s3_bucket"

  bucket_name                      = replace(local.config_bucket_replica_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.config_lambda_src_replica_bucket_policy.json
  key_arn                          = module.config_lambda_src_kms_key_replica_region2.arn
  access_log_bucket_arn            = module.account_s3_access_log_bucket_region2.arn
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

  sns_notifications = {
    security_sns = {
      topic_arn = module.securitynotification_sns_region2.topic_arn
      events    = ["s3:ObjectRemoved:Delete"]
    }
  }

  # S3-2  - Skipping OPA check for replicating s3 Buckets which doesn't require replication configuration
  # S3-3  - Skipping OPA check for s3 default KMS check as it is a false positive
  # S3-7  - Skipping OPA check for s3 KMS encryption check as it is a false positive
  # S3-9  - Skipping OPA check for s3 logging check as it is a false positive
  # S3-10 - Skipping OPA check for s3 logging check as it is a false positive
  # S3-12 - Skipping OPA check for lifecycle policy check as it is a false positive
  # S3-15 - Skipping OPA check for Object Lock s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-2/S3-3/S3-7/S3-9/S3-10/S3-12/S3-15"
  }

  providers = {
    aws = aws.region2
  }
}

module "config_lambda_src_kms_key_region1" {
  source = "./modules/kms_key"

  key_name            = "aft/${local.config_bucket_name}"
  key_policy          = data.aws_iam_policy_document.config_lambda_src_kms_key.json
  enable_multi_region = true

  providers = {
    aws = aws.region1
  }
}

module "config_lambda_src_kms_key_replica_region2" {
  source = "./modules/kms_key_replica"

  key_name        = "aft/${local.config_bucket_name}"
  key_policy      = data.aws_iam_policy_document.config_lambda_src_kms_key.json
  primary_key_arn = module.config_lambda_src_kms_key_region1.arn

  providers = {
    aws = aws.region2
  }
}

module "config_lambda_src_kms_key_replica_region3" {
  source = "./modules/kms_key_replica"

  key_name        = "aft/${local.config_bucket_name}"
  key_policy      = data.aws_iam_policy_document.config_lambda_src_kms_key.json
  primary_key_arn = module.config_lambda_src_kms_key_region1.arn

  providers = {
    aws = aws.region3
  }
}

module "config_lambda_src_access_logs_kms_key" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.config_bucket_name}_access_logs"
  key_policy = data.aws_iam_policy_document.config_lambda_src_access_logs_kms_key.json
}

module "config_lambda_src_replica_access_logs_kms_key" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.config_bucket_name}_replica_access_logs"
  key_policy = data.aws_iam_policy_document.config_lambda_src_access_logs_kms_key.json

  providers = {
    aws = aws.region2
  }
}

data "aws_iam_policy_document" "config_lambda_src_bucket_policy" {
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.
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
    resources = [module.config_lambda_src_bucket.arn, "${module.config_lambda_src_bucket.arn}/*"]
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
      values   = ["arn:aws:iam::*:role/aft/${local.config_bucket_name}_firehose*"]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [module.config_lambda_src_bucket.arn, "${module.config_lambda_src_bucket.arn}/*"]
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
    resources = [module.config_lambda_src_bucket.arn, "${module.config_lambda_src_bucket.arn}/*"]
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
    resources = ["${module.config_lambda_src_bucket.arn}/*"]
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

data "aws_iam_policy_document" "config_lambda_src_replica_bucket_policy" {
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.
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
    resources = [module.config_lambda_src_replica_bucket.arn, "${module.config_lambda_src_replica_bucket.arn}/*"]
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
      values   = ["arn:aws:iam::*:role/aft/${local.config_bucket_name}_firehose*"]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["s3:*"]
    resources = [module.config_lambda_src_replica_bucket.arn, "${module.config_lambda_src_replica_bucket.arn}/*"]
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
    resources = [module.config_lambda_src_replica_bucket.arn, "${module.config_lambda_src_replica_bucket.arn}/*"]
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
    resources = ["${module.config_lambda_src_replica_bucket.arn}/*"]
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

resource "aws_iam_role" "replication" {
  name = "s3-bucket-replication-${local.config_bucket_name}"
  path = "/aft/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy_document" "replication" {

  statement {
    sid = "AllowReplicationConfig"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [module.config_lambda_src_bucket.arn]
  }
  statement {
    sid = "AllowObjectVersions"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["${module.config_lambda_src_bucket.arn}/*"]
  }
  statement {
    sid = "AllowDestinationReplicaPermission"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    condition {
      test     = "StringLikeIfExists"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["aws:kms", "AES256", "aws:kms:dsse"]
    }
    condition {
      test     = "StringLikeIfExists"
      variable = "s3:x-amz-server-side-encryption-aws-kms-key-id"
      values   = [module.config_lambda_src_kms_key_replica_region2.arn]
    }
    resources = ["${module.config_lambda_src_replica_bucket.arn}/*"]
  }
  statement {
    sid = "AllowSourceKMSPermission"
    actions = [
      "kms:Decrypt"
    ]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.${module.config_lambda_src_bucket.region}.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${module.config_lambda_src_bucket.arn}/*"]
    }
    resources = [module.config_lambda_src_kms_key_region1.arn]
  }
  statement {
    sid = "AllowDestinationKMSPermission"
    actions = [
      "kms:Encrypt"
    ]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.${module.config_lambda_src_replica_bucket.region}.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"
      values   = ["${module.config_lambda_src_replica_bucket.arn}/*"]
    }
    resources = [module.config_lambda_src_kms_key_replica_region2.arn]
  }
}

resource "aws_iam_policy" "replication" {

  name   = "s3-bucket-replication-${local.config_bucket_name}"
  policy = data.aws_iam_policy_document.replication.json

  tags = {
    Name = "s3-bucket-replication-${local.config_bucket_name}"
  }
}

resource "aws_iam_policy_attachment" "replication" {

  name       = "s3-bucket-replication-${local.config_bucket_name}"
  roles      = [aws_iam_role.replication.name]
  policy_arn = aws_iam_policy.replication.arn
}

data "aws_iam_policy_document" "config_lambda_src_kms_key" {
  #checkov:skip=CKV_AWS_109:Condition is restricting to accounts only within the organizations or aws service principal.
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.

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
      values   = ["arn:aws:iam::*:role/aft/${local.config_bucket_name}_firehose*", aws_iam_role.replication.arn]
    }
  }
  statement {
    sid = "Allow Use of KMS"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:GenerateDataKey",
      "kms:Decrypt"
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
      values   = ["arn:aws:iam::*:role/AWSAFTExecution"]
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

data "aws_iam_policy_document" "config_lambda_src_access_logs_kms_key" {
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
