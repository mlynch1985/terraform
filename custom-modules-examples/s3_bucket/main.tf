#tfsec:ignore:aws-s3-enable-bucket-logging tfsec:ignore:aws-s3-enable-versioning
resource "aws_s3_bucket" "this" {
  #checkov:skip=CKV_AWS_18:Access Logging disabled for demo purposes
  #checkov:skip=CKV_AWS_19:KMS Encryption defined at stack level and not within this module
  #checkov:skip=CKV_AWS_21:Versioning defined at stack level and not within this module
  #checkov:skip=CKV_AWS_144:Replication disabled for demo purposes
  #checkov:skip=CKV_AWS_145:KMS Encryption defined at stack level and not within this module
  bucket_prefix = "${var.bucket_name}-"
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules

    content {
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

data "aws_iam_policy_document" "this" {
  count = length(var.iam_roles) > 0 ? 1 : 0

  statement {
    principals {
      type        = "AWS"
      identifiers = var.iam_roles
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:DeleteObject"
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "this" {
  count = length(var.iam_roles) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this[0].json
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
      kms_master_key_id = var.key_arn != "" ? var.key_arn : null
      sse_algorithm     = var.key_arn != "" ? "aws:kms" : "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count = var.versioning_option != "" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.versioning_option
  }
}
