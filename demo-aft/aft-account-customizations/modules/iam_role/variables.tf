# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "managed_policy_arns" {
  description = "Please provide a list of managed IAM policies ARNs to attach to this role"
  type        = list(string)
  default     = []
}

variable "max_session_duration" {
  type        = number
  description = "The maximum session duration (in seconds) for the role. Can have a value from 1 hour to 12 hours"
  default     = 3600
}

variable "path" {
  type        = string
  description = "Path to the role and policy. See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html) for more information."
  default     = "/"
}

variable "policy_description" {
  type        = string
  description = "The description of the IAM policy that is visible in the IAM policy manager"
  default     = ""
}

variable "policy_document" {
  type        = string
  description = "JSON IAM policy documents"
}

variable "principals" {
  type = list(object({
    type        = string
    identifiers = list(string)
  }))

  description = "List of principals objects with type and identifiers keys"

  validation {
    condition     = alltrue([for o in var.principals : contains(["AWS", "Service"], o.type)])
    error_message = "principals type must be AWS or Service"
  }
}

variable "role_description" {
  type        = string
  description = "The description of the IAM role that is visible in the IAM role manager"
  default     = ""
}

variable "role_name" {
  description = "Please specify a name for the IAM Role"
  type        = string
}
