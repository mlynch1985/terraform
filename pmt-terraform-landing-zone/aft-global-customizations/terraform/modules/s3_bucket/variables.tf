# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "bucket_name" {
  description = "Please specify a valid S3 Bucket Name that is globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "bucket_policy" {
  type        = string
  description = "JSON formatted IAM resource policy text"
}

variable "enable_intelligent_archive_tiers" {
  description = "Optionally enable Intelligent-Tiering Archive Access and Deep Archive Access tiers"
  type        = bool
}

variable "key_arn" {
  description = "Please specify the KMS Key ARN to encrypt the bucket with"
  type        = string
}

variable "lifecycle_rules" {
  description = "Specify a list of lifecycle rule maps"
  type = list(object({
    id                       = string
    status                   = string
    expire_days              = number
    noncurrent_days          = number
    noncurrent_storage_class = string
    noncurrent_versions      = number
    transition_days          = number
    transition_storage_class = string
  }))
  default = []
}

variable "object_lock_enabled" {
  description = "Whether S3 bucket should have an Object Lock configuration enabled."
  type        = bool
  default     = false
}

variable "object_lock_configuration" {
  description = "Map containing S3 object locking configuration."
  type        = any
  default = {
    rule = {
      default_retention = {
        mode = "COMPLIANCE"
        days = 1
      }
    }
  }
}

variable "sns_notifications" {
  description = "Map of S3 bucket notifications to SNS topic"
  type        = any
  default     = {}

  /*
  # Sample input
  sns_notifications = {
    sns1 = {
      topic_arn     = module.sns_topic1.sns_topic_arn
      events        = ["s3:ObjectRemoved:Delete"]
      filter_prefix = "prefix3/"
      filter_suffix = ".csv"
    }

    sns2 = {
      topic_arn = module.sns_topic2.sns_topic_arn
      events    = ["s3:ObjectRemoved:DeleteMarkerCreated"]
    }
  }
  */
}

variable "replication_configuration" {
  description = "Map containing cross-region replication configuration."
  default     = {}
  type        = any
  # type = object({
  #   role = optional(string)
  #   rules = optional(list(object({
  #     id                        = string
  #     status                    = string
  #     priority                  = optional(number)
  #     delete_marker_replication = bool
  #     source_selection_criteria = optional(object({
  #       replica_modifications = optional(object({
  #         status = string
  #       }))
  #       sse_kms_encrypted_objects = object({
  #         enabled = bool
  #       })
  #     }))
  #     filter = optional(object({
  #       prefix = string
  #       tags   = any
  #     }))
  #     destination = object({
  #       bucket             = string
  #       storage_class      = string
  #       replica_kms_key_id = string
  #       account_id         = optional(number)
  #       access_control_translation = optional(object({
  #         owner = string
  #       }))
  #       replication_time = optional(object({
  #         status  = string
  #         minutes = number
  #       }))
  #       metrics = optional(object({
  #         status  = string
  #         minutes = number
  #       }))
  #     })
  #   })))
  # })

  /*
  # example setup
  replication_configuration = {
      role = aws_iam_role.replication.arn

      rules = [
        {
          id       = "something-with-kms-and-filter"
          status   = true
          priority = 10

          delete_marker_replication = false

          source_selection_criteria = {
            replica_modifications = {
              status = "Enabled"
            }
            sse_kms_encrypted_objects = {
              enabled = true
            }
          }

          filter = {
            prefix = "one"
            tags = {
              ReplicateMe = "Yes"
            }
          }

          destination = {
            bucket        = "arn:aws:s3:::replica_bucket_name"
            storage_class = "STANDARD"

            replica_kms_key_id = aws_kms_key.replica.arn
            account_id         = data.aws_caller_identity.current.account_id

            access_control_translation = {
              owner = "Destination"
            }

            replication_time = {
              status  = "Enabled"
              minutes = 15
            }

            metrics = {
              status  = "Enabled"
              minutes = 15
            }
          }
        },
        {
          id       = "something-with-filter"
          priority = 20

          delete_marker_replication = false

          filter = {
            prefix = "two"
            tags = {
              ReplicateMe = "Yes"
            }
          }

          destination = {
            bucket        = "arn:aws:s3:::replica_bucket_name"
            storage_class = "STANDARD"
          }
        },
        {
          id       = "everything-with-filter"
          status   = "Enabled"
          priority = 30

          delete_marker_replication = true

          filter = {
            prefix = ""
          }

          destination = {
            bucket        = "arn:aws:s3:::replica_bucket_name"
            storage_class = "STANDARD"
          }
        },
        {
          id     = "everything-without-filters"
          status = "Enabled"

          delete_marker_replication = true

          destination = {
            bucket        = "arn:aws:s3:::replica_bucket_name"
            storage_class = "STANDARD"
          }
        },
      ]
    }
  */
}

variable "tags" {
  type        = map(string)
  description = "Provide a map of AWS Tags to add to each bucket"
  default     = {}
}

variable "access_log_bucket_arn" {
  type        = string
  description = "Bucket ARN for access log"
}

variable "use_cmk_key" {
  type        = bool
  default     = true
  description = "For LB access log this has to be false"
}
