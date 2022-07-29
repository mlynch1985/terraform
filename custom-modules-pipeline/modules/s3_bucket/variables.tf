variable "bucket_name" {
  description = "Provide an S3 Bucket Name to store artifacts and logs for this pipeline"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,37}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,37}$)"
  }
}

variable "key_arn" {
  description = "Provide a KMS Customer Managed Key (CMK) ARN to encrypt the bucket"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
  }
}

variable "iam_roles" {
  description = "Please specify a list of valid IAM Roles to be granted read/write access to this bucket"
  type        = list(string)

  validation {
    condition = alltrue([
      for iam_role in var.iam_roles : can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$", iam_role))
    ])
    error_message = "Please provide a list of at least one valid IAM Role ARN"
  }
}
