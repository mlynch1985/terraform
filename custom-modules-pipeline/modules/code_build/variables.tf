variable "codebuild_name" {
  description = "Provide a friendly name for your CodeBuild Project"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codebuild_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}

variable "role_arn" {
  description = "Provide the IAM Role ARN to be used by the CodeBuild Project"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$", var.role_arn))
    error_message = "Please specify a valid IAM Role (^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$)"
  }
}

variable "role_name" {
  description = "Provide the IAM Role Name to attach new IAM Policies to"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9._-]{1,64}", var.role_name))
    error_message = "Must be an alphanumeric value and a max length of 64 characters"
  }
}

variable "bucket_name" {
  description = "Provide the name of the S3 Bucket to publish the TF Modules into"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "codecommit_arn" {
  description = "Provide the CodeCommit Repository ARN to pull the source code from"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:codecommit:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:[a-zA-Z0-9-_]{1,96}$", var.codecommit_arn))
    error_message = "Please specify a valid CodeCommit Repository (^arn:aws:codecommit:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:[a-zA-Z0-9-_]{1,96}$)"
  }
}
