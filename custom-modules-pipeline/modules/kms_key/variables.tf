variable "key_name" {
  description = "Provide a friendly name for your KMS Key Alias"
  type        = string

  validation {
    condition     = can(regex("^[/-_a-zA-Z0-9]{1,32}", var.key_name))
    error_message = "Must be an alphanumeric value including underscores, hyphens and forward slashes and a max length of 32 characters"
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
