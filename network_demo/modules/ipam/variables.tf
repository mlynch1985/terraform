variable "allocation_default_netmask_length" {
  description = "Please specify the default netmask length for new VPC CIDRs"
  type        = number
  default     = 16

  validation {
    condition     = var.allocation_default_netmask_length >= 16 && var.allocation_default_netmask_length <= 28
    error_message = "Please specify a valid default size between 16 and 28"
  }
}

variable "cidr" {
  description = "Please specify the IPAM Pool CIDR"
  type        = string

  validation {
    condition     = can(regex("^(10|172|192)(.[0-9]{1,3}){3}/([8,9]|1[0-9]|2[0-4])$", var.cidr))
    error_message = "Please specify a valid private CIDR between /8 and /24"
  }
}

variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}
