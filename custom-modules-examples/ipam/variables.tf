variable "allocation_default_netmask_length" {
  description = "Please specify the default netmask length for new VPC CIDRs"
  type        = number
  default     = 20

  validation {
    condition     = var.allocation_default_netmask_length >= 16 && var.allocation_default_netmask_length <= 26
    error_message = "Please specify a valid default size between 16 and 26"
  }
}

variable "allocation_max_netmask_length" {
  description = "Please specify the maximum netmask length for new VPC CIDRs"
  type        = number
  default     = 26

  validation {
    condition     = var.allocation_max_netmask_length >= 18 && var.allocation_max_netmask_length <= 28
    error_message = "Please specify a valid maximum size between 18 and 28"
  }
}

variable "allocation_min_netmask_length" {
  description = "Please specify the minimum netmask length for new VPC CIDRs"
  type        = number
  default     = 16

  validation {
    condition     = var.allocation_min_netmask_length >= 16 && var.allocation_min_netmask_length <= 26
    error_message = "Please specify a valid minimum size between 16 and 26"
  }
}

variable "ipam_cidr" {
  description = "Please specify the IPAM Pool CIDR"
  type        = string

  validation {
    condition     = can(regex("^(10|172|192)(.[0-9]{1,3}){3}/([8,9]|1[0-9]|2[0-4])$", var.ipam_cidr))
    error_message = "Please specify a valid private CIDR between /8 and /24"
  }
}

variable "home_region" {
  description = "Specify the AWS region to deploy the main IPAM Pool into"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.home_region))
    error_message = "Must be a valid AWS Region name"
  }
}
