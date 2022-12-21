variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}

variable "subnets" {
  description = "List of subnet IDs to deploy the ELB into"
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(regex("^subnet-[0-9a-zA-Z]{17}$", subnet))
    ])
    error_message = "Please specify a list containing at least one valid Subnet ID (^subnet-[0-9a-zA-Z]{17}$)"
  }
}

variable "certificate_arn" {
  description = "The ACM Certificate ARN to attach to TLS enabled listeners"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "Provide the VPC ID where to provision the Target Groups"
  type        = string
}

variable "instance_ids" {
  description = "Provide a list of instance IDs to attach to the Target Groups"
  type        = list(string)
}

variable "assume_role_arn" {
  description = "The IAM Role ARN used in the provider block to target the workloads account"
  type        = string
}
