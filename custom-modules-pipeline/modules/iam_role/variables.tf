variable "service" {
  description = "Provide the AWS Service Name prefix (eg. before the .amazonaws.com)"
  type        = string

  validation {
    condition     = can(regex("[a-z0-9]{1,24}", var.service))
    error_message = "Must be an alphanumeric and lowercase and a max length of 24 characters"
  }
}

variable "role_name" {
  description = "Provide a friendly name for your IAM Role"
  type        = string

  validation {
    condition     = can(regex("[a-zA-Z0-9._-]{1,24}", var.role_name))
    error_message = "Must be an alphanumeric value including periods, underscores and hyphens and a max length of 24 characters"
  }
}
