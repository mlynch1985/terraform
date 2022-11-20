variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}

variable "vpc_ids" {
  description = "Please specify a list of VPC IDs to configure Flow Logs for"
  type        = list(string)

  validation {
    condition = alltrue([
      for vpc_id in var.vpc_ids : can(regex("^vpc-[0-9a-z]{17}$", vpc_id))
    ])
    error_message = "Please specify a list of VPC IDs to configure Flow Logs for"
  }
}
