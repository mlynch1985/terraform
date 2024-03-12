# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_s3_bucket" "this" {
  #checkov:skip=CKV_AWS_144:This is false positive. We have cross region replication enabled with variable "replication_configuration"
  #checkov:skip=CKV2_AWS_62:This is false positive. We have SNS notifications enabled with variable "sns_notifications"

  bucket              = "${var.bucket_name}-${data.aws_caller_identity.current.account_id}-${data.aws_region.current.name}"
  object_lock_enabled = var.object_lock_enabled
  force_destroy       = true
  tags                = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count = length(var.lifecycle_rules) > 0 ? 1 : 0

  #checkov:skip=CKV_AWS_300:This is false positive. We have Lifecycle configuration for abort failed uploads
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
  #checkov:skip=CKV_AWS_144:This is false positive. We dont need to have cross region replication enabled for S3 access logging bucket

  bucket        = aws_s3_bucket.this.id
  target_bucket = local.access_log_bucket_id
  target_prefix = "${aws_s3_bucket.this.id}/"
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count = length(keys(var.replication_configuration)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id
  role   = var.replication_configuration["role"]

  dynamic "rule" {
    for_each = flatten(try([var.replication_configuration["rule"]], [var.replication_configuration["rules"]], []))

    content {
      id       = try(rule.value.id, null)
      priority = try(rule.value.priority, null)
      # prefix = try(rule.value.prefix, null)
      status = try(tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)), "Enabled")

      dynamic "delete_marker_replication" {
        for_each = flatten(try([rule.value.delete_marker_replication_status], [rule.value.delete_marker_replication], []))

        content {
          # Valid values: "Enabled" or "Disabled"
          status = try(tobool(delete_marker_replication.value) ? "Enabled" : "Disabled", title(lower(delete_marker_replication.value)))
        }
      }

      # Amazon S3 does not support this argument according to:
      # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration
      # More infor about what does Amazon S3 replicate?
      # https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-what-is-isnot-replicated.html
      dynamic "existing_object_replication" {
        for_each = flatten(try([rule.value.existing_object_replication_status], [rule.value.existing_object_replication], []))

        content {
          # Valid values: "Enabled" or "Disabled"
          status = try(tobool(existing_object_replication.value) ? "Enabled" : "Disabled", title(lower(existing_object_replication.value)))
        }
      }

      dynamic "destination" {
        for_each = try(flatten([rule.value.destination]), [])

        content {
          bucket        = destination.value.bucket
          storage_class = try(destination.value.storage_class, null)
          account       = try(destination.value.account_id, destination.value.account, null)

          dynamic "access_control_translation" {
            for_each = try(flatten([destination.value.access_control_translation]), [])

            content {
              owner = title(lower(access_control_translation.value.owner))
            }
          }

          dynamic "encryption_configuration" {
            for_each = flatten([try(destination.value.encryption_configuration.replica_kms_key_id, destination.value.replica_kms_key_id, [])])

            content {
              replica_kms_key_id = encryption_configuration.value
            }
          }

          dynamic "replication_time" {
            for_each = try(flatten([destination.value.replication_time]), [])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(replication_time.value.status) ? "Enabled" : "Disabled", title(lower(replication_time.value.status)), "Disabled")

              dynamic "time" {
                for_each = try(flatten([replication_time.value.minutes]), [])

                content {
                  minutes = replication_time.value.minutes
                }
              }
            }

          }

          dynamic "metrics" {
            for_each = try(flatten([destination.value.metrics]), [])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(metrics.value.status) ? "Enabled" : "Disabled", title(lower(metrics.value.status)), "Disabled")

              dynamic "event_threshold" {
                for_each = try(flatten([metrics.value.minutes]), [])

                content {
                  minutes = metrics.value.minutes
                }
              }
            }
          }
        }
      }

      dynamic "source_selection_criteria" {
        for_each = try(flatten([rule.value.source_selection_criteria]), [])

        content {
          dynamic "replica_modifications" {
            for_each = flatten([try(source_selection_criteria.value.replica_modifications.enabled, source_selection_criteria.value.replica_modifications.status, [])])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(replica_modifications.value) ? "Enabled" : "Disabled", title(lower(replica_modifications.value)), "Disabled")
            }
          }

          dynamic "sse_kms_encrypted_objects" {
            for_each = flatten([try(source_selection_criteria.value.sse_kms_encrypted_objects.enabled, source_selection_criteria.value.sse_kms_encrypted_objects.status, [])])

            content {
              # Valid values: "Enabled" or "Disabled"
              status = try(tobool(sse_kms_encrypted_objects.value) ? "Enabled" : "Disabled", title(lower(sse_kms_encrypted_objects.value)), "Disabled")
            }
          }
        }
      }

      # Max 1 block - filter - without any key arguments or tags
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []

        content {
        }
      }

      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]

        content {
          prefix = try(filter.value.prefix, null)

          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])

            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }

      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]

        content {
          and {
            prefix = try(filter.value.prefix, null)
            tags   = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }

  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.this, aws_s3_bucket_logging.this]
}


module "sns_notifications_bucket" {
  source = "./notification"

  count = length(keys(var.sns_notifications)) > 0 ? 1 : 0

  bucket            = aws_s3_bucket.this.id
  sns_notifications = var.sns_notifications
  create_sqs_policy = false
  create_sns_policy = false
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = var.object_lock_enabled && try(var.object_lock_configuration.rule.default_retention, null) != null ? 1 : 0

  bucket = aws_s3_bucket.this.id
  rule {
    default_retention {
      mode  = var.object_lock_configuration.rule.default_retention.mode
      days  = try(var.object_lock_configuration.rule.default_retention.days, null)
      years = try(var.object_lock_configuration.rule.default_retention.years, null)
    }
  }
}
