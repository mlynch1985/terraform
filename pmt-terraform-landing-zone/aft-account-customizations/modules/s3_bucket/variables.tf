# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "access_logs_key_arn" {
  description = "Please specify the KMS Key ARN to encrypt the access logs bucket with"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.access_logs_key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
  }
}

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

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
  }
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
