# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}
data "aws_region" "current" {}

# S3 ACCESS LOGS BUCKET
resource "aws_s3_bucket" "access_logs" {
  #checkov:skip=CKV2_AWS_62:Not turning on notification for access log bucket.
  #checkov:skip=CKV_AWS_144:This is false positive. We dont need to have cross region replication enabled for S3 access logging bucket
  #checkov:skip=CKV_AWS_18:This is false positive. We dont need to have access log enabled for S3 access logging bucket

  bucket        = "${var.bucket_name}-s3-access-logs-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  force_destroy = true

  # S3-2  - Skipping OPA check for access_logs S3 buckets which doesn't require replication configured.
  # S3-10 - Skipping OPA check for access_logs S3 buckets which doesn't require logging enabled.
  # S3-12 - Skipping OPA check for access_logs S3 buckets which doesn't require lifecycle configuration rules.
  # S3-15 - Skipping OPA check for access_logs s3 Buckets which doesn't require object lock configuration
  tags = {
    "opa_skip" = "S3-2/S3-10/S3-12/S3-15"
  }
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
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:SourceAccount"
    #   values   = [data.aws_caller_identity.current.account_id]
    # }
    # condition {
    #   test     = "ArnLike"
    #   variable = "aws:SourceArn"
    #   values   = ["arn:aws:s3:::*"]
    #   # values   = [aws_s3_bucket.this.arn]
    # }
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
