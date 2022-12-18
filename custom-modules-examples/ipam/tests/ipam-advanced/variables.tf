variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}
