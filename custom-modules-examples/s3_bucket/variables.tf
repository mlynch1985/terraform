variable "bucket_name" {
  description = "Please specify a valid S3 Bucket Name that is globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "iam_roles" {
  description = "Please specify a list of valid IAM Roles to be granted S3 Bucket Usage access"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for iam_role in var.iam_roles : can(regex("^$|^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$", iam_role))
    ])
    error_message = "Please provide a list of at least one valid IAM Role ARN to be granted S3 Bucket access"
  }
}

variable "key_arn" {
  description = "Please specify the KMS Key ARN to encrypt the bucket with"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^$|^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.key_arn))
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

variable "versioning_option" {
  description = "Specify the versioning option"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "Enabled", "Disabled", "Suspended"], var.versioning_option)
    error_message = "Please specify a valid versioning option: \"\", \"Enabled\", \"Disabled\", \"Suspended\""
  }
}
