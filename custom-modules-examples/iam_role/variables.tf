variable "service" {
  description = "Please specify the AWS Service name prefix without the \".amazonaws.com\" domain"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,36}$", var.service))
    error_message = "Please specify a valid AWS Server name prefex (^[a-zA-Z0-9]{1,36}$)"
  }
}

variable "role_name" {
    description = "Please specify a name for the IAM Role"
    type = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]{1,36}$", var.role_name))
    error_message = "Please specify a IAM role name prefex (^[a-zA-Z0-9-_]{1,36}$)"
  }
}
