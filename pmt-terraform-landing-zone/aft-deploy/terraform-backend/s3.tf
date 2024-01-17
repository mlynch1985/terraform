resource "aws_s3_bucket" "secure_s3_bucket" { #tfsec:ignore:aws-s3-enable-bucket-logging
  bucket = "${var.bucket_name}-${data.aws_caller_identity.current.id}"

  force_destroy = var.force_destroy
  

  tags = merge(
    var.tags,
    {
      "Name" = var.bucket_name
    }
  )
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.secure_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "secure_s3_bucket_versioning" {
  bucket = aws_s3_bucket.secure_s3_bucket.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = var.mfa_delete ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "secure_s3_bucket_lc" {
  bucket = aws_s3_bucket.secure_s3_bucket.id

  rule {
    id     = "auto-archive"
    status = "Enabled"

    filter {
      prefix = "/"
    }

    dynamic "transition" {
      for_each = length(keys(var.lifecycle_rule_current_version)) == 0 ? [] : [
        var.lifecycle_rule_current_version
      ]

      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }
    dynamic "noncurrent_version_transition" {
      for_each = length(keys(var.lifecycle_rule_noncurrent_version)) == 0 ? [] : [
        var.lifecycle_rule_noncurrent_version
      ]

      content {
        noncurrent_days = noncurrent_version_transition.value.days
        storage_class   = noncurrent_version_transition.value.storage_class
      }
    }

    expiration {
      date                         = var.lifecycle_rule_expiration.date
      days                         = var.lifecycle_rule_expiration.days
      expired_object_delete_marker = var.lifecycle_rule_expiration.expired_object_delete_marker
    }
  }

}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_s3_bucket_sse" {
  bucket = aws_s3_bucket.secure_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state_key.id
    }
  }
}