# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  lb_access_bucket_name = "common-lb-access-log"
}

module "lb_access_src_bucket_region1" {
  #checkov:skip=CKV_AWS_300:Lifecycle rule is set but checkov is producing false positive
  source = "./modules/s3_bucket"

  bucket_name                      = replace(local.lb_access_bucket_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.lb_access_src_bucket_policy_region1.json
  use_cmk_key                      = false
  key_arn                          = null
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

  sns_notifications = {
    lb_security_sns = {
      topic_arn = module.securitynotification_sns_region1.topic_arn
      events    = ["s3:ObjectRemoved:Delete"]
    }
  }

  # S3-2  - Skipping OPA check for s3 bucket replication as it doesn't require for access log bucket
  # S3-3  - Skipping OPA check for s3 default kms encryption as it is not supported for access logs
  # S3-7  - Skipping OPA check for s3 bucket server side encryption as it is not supported for access logs
  # S3-9  - Skipping OPA check for s3 bucket versioning as it is a false positive
  # S3-10 - Skipping OPA check as it is a false positive
  # S3-12 - Skipping OPA check for lifecycle policy check as it is a false positive
  # S3-15 - Skipping OPA check for object lock s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-2/S3-3/S3-7/S3-9/S3-10/S3-12/S3-15"
  }
}

module "lb_access_src_bucket_region2" {
  #checkov:skip=CKV_AWS_300:Lifecycle rule is set but checkov is producing false positive
  source = "./modules/s3_bucket"

  bucket_name                      = replace(local.lb_access_bucket_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.lb_access_src_bucket_policy_region2.json
  use_cmk_key                      = false
  key_arn                          = null
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
    lb_security_sns = {
      topic_arn = module.securitynotification_sns_region2.topic_arn
      events    = ["s3:ObjectRemoved:Delete"]
    }
  }

  # S3-2  - Skipping OPA check for s3 bucket replication as it doesn't require for access log bucket
  # S3-3  - Skipping OPA check for s3 default kms encryption as it is not supported for access logs
  # S3-7  - Skipping OPA check for s3 bucket server side encryption as it is not supported for access logs
  # S3-9  - Skipping OPA check for s3 bucket versioning as it is a false positive
  # S3-10 - Skipping OPA check as it is a false positive
  # S3-12 - Skipping OPA check for lifecycle policy check as it is a false positive
  # S3-15 - Skipping OPA check for object lock s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-2/S3-3/S3-7/S3-9/S3-10/S3-12/S3-15"
  }

  providers = {
    aws = aws.region2
  }
}

module "lb_access_src_bucket_region3" {
  #checkov:skip=CKV_AWS_300:Lifecycle rule is set but checkov is producing false positive
  source = "./modules/s3_bucket"

  bucket_name                      = replace(local.lb_access_bucket_name, "_", "-")
  bucket_policy                    = data.aws_iam_policy_document.lb_access_src_bucket_policy_region3.json
  use_cmk_key                      = false
  key_arn                          = null
  access_log_bucket_arn            = module.account_s3_access_log_bucket_region3.arn
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
    lb_security_sns = {
      topic_arn = module.securitynotification_sns_region3.topic_arn
      events    = ["s3:ObjectRemoved:Delete"]
    }
  }

  # S3-2  - Skipping OPA check for s3 bucket replication as it doesn't require for access log bucket
  # S3-3  - Skipping OPA check for s3 default kms encryption as it is not supported for access logs
  # S3-7  - Skipping OPA check for s3 bucket server side encryption as it is not supported for access logs
  # S3-9  - Skipping OPA check for s3 bucket versioning as it is a false positive
  # S3-10 - Skipping OPA check as it is a false positive
  # S3-12 - Skipping OPA check for lifecycle policy check as it is a false positive
  # S3-15 - Skipping OPA check for object lock s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-2/S3-3/S3-7/S3-9/S3-10/S3-12/S3-15"
  }

  providers = {
    aws = aws.region3
  }
}

resource "aws_ssm_parameter" "lb_access_src_bucket_region1_arn" {
  count  = local.ct_management_account_id != data.aws_caller_identity.current.account_id ? 1 : 0
  name   = "/aft/account/lb_access_src_bucket_arn"
  type   = "SecureString"
  value  = module.lb_access_src_bucket_region1.arn
  key_id = module.secretsmanager_kms_key_region1.arn

  provider = aws.region1
}

resource "aws_ssm_parameter" "lb_access_src_bucket_region2_arn" {
  count  = local.ct_management_account_id != data.aws_caller_identity.current.account_id ? 1 : 0
  name   = "/aft/account/lb_access_src_bucket_arn"
  type   = "SecureString"
  value  = module.lb_access_src_bucket_region2.arn
  key_id = module.secretsmanager_kms_key_region2.arn

  provider = aws.region2
}

resource "aws_ssm_parameter" "lb_access_src_bucket_region3_arn" {
  count  = local.ct_management_account_id != data.aws_caller_identity.current.account_id ? 1 : 0
  name   = "/aft/account/lb_access_src_bucket_arn"
  type   = "SecureString"
  value  = module.lb_access_src_bucket_region3.arn
  key_id = module.secretsmanager_kms_key_region3.arn

  provider = aws.region3
}


data "aws_iam_policy_document" "lb_access_src_bucket_policy_region1" {
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
    resources = [module.lb_access_src_bucket_region1.arn, "${module.lb_access_src_bucket_region1.arn}/*"]
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
      values   = ["arn:aws:iam::*:role/aft/${local.lb_access_bucket_name}_firehose*"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region1.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<PLACEHOLDER>:root"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region1.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region1.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      module.lb_access_src_bucket_region1.arn
    ]
  }
  statement {
    sid       = "RestrictToTLSRequestsOnly"
    effect    = "Deny"
    actions   = ["*"]
    resources = [module.lb_access_src_bucket_region1.arn, "${module.lb_access_src_bucket_region1.arn}/*"]
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
}

data "aws_iam_policy_document" "lb_access_src_bucket_policy_region2" {
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
    resources = [module.lb_access_src_bucket_region2.arn, "${module.lb_access_src_bucket_region2.arn}/*"]
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
      values   = ["arn:aws:iam::*:role/aft/${local.lb_access_bucket_name}_firehose*"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region2.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<PLACEHOLDER>:root"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region2.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region2.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      module.lb_access_src_bucket_region2.arn
    ]
  }
  statement {
    sid       = "RestrictToTLSRequestsOnly"
    effect    = "Deny"
    actions   = ["*"]
    resources = [module.lb_access_src_bucket_region2.arn, "${module.lb_access_src_bucket_region2.arn}/*"]
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
}

data "aws_iam_policy_document" "lb_access_src_bucket_policy_region3" {
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
    resources = [module.lb_access_src_bucket_region3.arn, "${module.lb_access_src_bucket_region3.arn}/*"]
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
      values   = ["arn:aws:iam::*:role/aft/${local.lb_access_bucket_name}_firehose*"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region3.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<PLACEHOLDER>:root"]
    }
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region3.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["logdelivery.elasticloadbalancing.amazonaws.com"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryWrite"
    effect = "Allow"
    actions = [
      "s3:PutObject"
    ]
    resources = ["${module.lb_access_src_bucket_region3.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
  statement {
    sid    = "AWSLogDeliveryAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions = [
      "s3:GetBucketAcl",
      "s3:ListBucket",
    ]
    resources = [
      module.lb_access_src_bucket_region3.arn
    ]
  }
  statement {
    sid       = "RestrictToTLSRequestsOnly"
    effect    = "Deny"
    actions   = ["*"]
    resources = [module.lb_access_src_bucket_region3.arn, "${module.lb_access_src_bucket_region3.arn}/*"]
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
}
