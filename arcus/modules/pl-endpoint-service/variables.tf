variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}

variable "assume_role_arn" {
  description = "The IAM Role ARN used in the provider block to target the workloads account"
  type        = string
}

variable "allowed_principals" {
  description = "A list of IAM ARNs to allow usage of this Private Link Service"
  type        = list(string)
}

variable "network_load_balancer_arns" {
  description = "The NLB ARN to connect"
  type        = list(string)
}
