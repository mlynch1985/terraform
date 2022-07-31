variable "role_name" {
  description = "Please specify a name prefix for the IAM Role"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,36}$", var.role_name))
    error_message = "Please specify a IAM role name prefix (^[a-zA-Z0-9-_]{1,36}$)"
  }
}

variable "service" {
  description = "Please specify the AWS Service name prefix without the \".amazonaws.com\" domain"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,36}$", var.service))
    error_message = "Please specify a valid AWS Service name prefex (^[a-zA-Z0-9]{1,36}$)"
  }
}

variable "inline_policy_json" {
  description = "Please provide a JSON IAM Policy to attach to this role"
  type        = string
  default     = ""
}

variable "managed_policy_arns" {
  description = "Please provide a list of managed IAM policies ARNs to attach to this role"
  type        = list(string)
  default     = []
}
