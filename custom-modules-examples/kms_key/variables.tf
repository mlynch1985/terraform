variable "key_name" {
  description = "Please specify a valid KMS Key Name to be used for the Alias"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_/]{1,32}$", var.key_name))
    error_message = "Please specify a valid KMS Key Name (^[a-zA-Z0-9-_/]{1,32}$)"
  }
}

variable "iam_roles" {
  description = "Please specify a list of valid IAM Roles to be granted KMS Key Usage access"
  type        = list(string)

  validation {
    condition = alltrue([
      for iam_role in var.iam_roles : can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$", iam_role))
    ])
    error_message = "Please provide a list of at least one valid IAM Role ARN to be granted KMS Key access"
  }
}

variable "enable_multi_region" {
  description = "Please specify either \"true\" or \"false\" to enable Multi-Region support for the KMS Key"
  type        = bool
  default     = false
}
