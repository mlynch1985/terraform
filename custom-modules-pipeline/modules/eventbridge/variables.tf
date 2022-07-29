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

variable "codecommit_name" {
  description = "Provide the CodeCommit Repository Name to pull the source code from"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9]{1,24}", var.codecommit_name))
    error_message = "Must be an alphanumeric value and a max length of 24 characters"
  }
}

variable "codepipeline_arn" {
  description = "Provide the CodePipeline Pipeline ARN to trigger"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:codepipeline:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:[a-zA-Z0-9-_]{1,96}$", var.codepipeline_arn))
    error_message = "Please specify a valid CodeCommit Repository (^arn:aws:codepipeline:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:[a-zA-Z0-9-_]{1,96}$)"
  }
}
