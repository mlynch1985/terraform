variable "codepipeline_name" {
  description = "Provide a friendly name for your CodePipeline pipeline"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codepipeline_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}

variable "role_arn" {
  description = "Provide an IAM Role ARN used to execute this pipeline"
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
  description = "Provide an S3 Bucket Name to store artifacts and logs for this pipeline"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "pipeline_key_arn" {
  description = "Provide a KMS Customer Managed Key (CMK) ARN to encrypt the pipeline"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.pipeline_key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
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

variable "codecommit_name" {
  description = "Provide the CodeCommit Repository Name to pull the source code from"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codecommit_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}

variable "codebuild_name" {
  description = "Provide the CodeBuild Project Name to trigger within this pipeline"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codebuild_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}
