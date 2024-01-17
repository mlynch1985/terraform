# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "this" {
  bucket        = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {

      abort_incomplete_multipart_upload {
        days_after_initiation = 30
      }

      id     = rule.value.id
      status = rule.value.status

      expiration {
        days = rule.value.expire_days > 0 ? rule.value.expire_days : null
      }

      noncurrent_version_transition {
        newer_noncurrent_versions = rule.value.noncurrent_versions > 0 ? rule.value.noncurrent_versions : null
        noncurrent_days           = rule.value.noncurrent_days > 0 ? rule.value.noncurrent_days : null
        storage_class             = rule.value.noncurrent_storage_class != "" ? rule.value.noncurrent_storage_class : "INTELLIGENT_TIERING"
      }

      transition {
        days          = rule.value.transition_days > 0 ? rule.value.transition_days : null
        storage_class = rule.value.transition_storage_class != "" ? rule.value.transition_storage_class : "INTELLIGENT_TIERING"
      }
    }
  }
}

# Optionally enable Intelligent-Tiering Archive Access and Deep Archive Access tiers
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-intelligent-tiering.html#enable-auto-archiving-int-tiering
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  count = var.enable_intelligent_archive_tiers ? 1 : 0

  bucket = aws_s3_bucket.this.id
  name   = "IntelligentTieringArchive"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
}

resource "aws_s3_bucket_policy" "this" {

  bucket = aws_s3_bucket.this.id
  policy = var.bucket_policy
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_logging" "this" {
  bucket = aws_s3_bucket.this.id

  target_bucket = aws_s3_bucket.access_logs.id
  target_prefix = "log/"
}

# S3 ACCESS LOGS BUCKET
resource "aws_s3_bucket" "access_logs" {
  bucket        = "${var.bucket_name}-s3-access-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.access_logs_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

data "aws_iam_policy_document" "access_logs" {

  statement {
    sid       = "AllowPutObjectS3ServerAccessLogsPolicy"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [aws_s3_bucket.this.arn]
    }
  }

  statement {
    sid       = "RestrictToS3ServerAccessLogs"
    effect    = "Deny"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "ForAllValues:StringNotEquals"
      variable = "aws:PrincipalServiceNamesList"
      values   = ["logging.s3.amazonaws.com"]
    }
  }

  statement {
    sid     = "EnforceIdentityPerimeter"
    effect  = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.access_logs.arn,
      "${aws_s3_bucket.access_logs.arn}/*",
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
      aws_s3_bucket.access_logs.arn,
      "${aws_s3_bucket.access_logs.arn}/*",
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
    resources = ["${aws_s3_bucket.access_logs.arn}/*"]
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

resource "aws_s3_bucket_policy" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  policy = data.aws_iam_policy_document.access_logs.json
}

resource "aws_s3_bucket_ownership_controls" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "access_logs" {
  bucket = aws_s3_bucket.access_logs.id
  name   = "IntelligentTieringArchive"

  tiering {
    access_tier = "DEEP_ARCHIVE_ACCESS"
    days        = 180
  }
  tiering {
    access_tier = "ARCHIVE_ACCESS"
    days        = 90
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "access_logs" {

  bucket = aws_s3_bucket.access_logs.id

  rule {
    abort_incomplete_multipart_upload {
      days_after_initiation = 30
    }

    id     = "default"
    status = "Enabled"

    transition {
      days          = "1"
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}
