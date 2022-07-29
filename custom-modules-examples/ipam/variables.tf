variable "region" {
  description = "Please specify the AWS Region to deploy the IPAM Pool into"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z][a-z]-[a-z]+-[1-9]$", var.region))
    error_message = "Please specify a valid AWS Region name"
  }
}

variable "namespace" {
  description = "Please specify a unique namespace to prefix resources specific to this deployment"
  type        = string
  default     = "use1d"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{1,12}$", var.namespace))
    error_message = "Please specify an alphanumeric namesapce between 1 and 12 characters long"
  }
}

variable "environment" {
  description = "Please specify the environment for this deployment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "staging", "production"], var.environment)
    error_message = "Please specify the environment from either \"dev\", \"test\", \"staging\", \"production\""
  }
}

variable "allocation_default_netmask_length" {
  description = "Please specify the default netmask length for new VPC CIDRs"
  type        = number
  default     = 20

  validation {
    condition     = var.allocation_default_netmask_length >= 16 && var.allocation_default_netmask_length <= 28
    error_message = "Please specify a valid default size between 16 and 28"
  }
}

variable "allocation_min_netmask_length" {
  description = "Please specify the minimum netmask length for new VPC CIDRs"
  type        = number
  default     = 16

  validation {
    condition     = var.allocation_min_netmask_length >= 16 && var.allocation_min_netmask_length <= 24
    error_message = "Please specify a valid minimum size between 16 and 24"
  }
}

variable "allocation_max_netmask_length" {
  description = "Please specify the maximum netmask length for new VPC CIDRs"
  type        = number
  default     = 28

  validation {
    condition     = var.allocation_max_netmask_length >= 20 && var.allocation_max_netmask_length <= 28
    error_message = "Please specify a valid maximum size between 20 and 28"
  }
}

variable "ipam_cidr" {
  description = "Please specify the IPAM Pool CIDR"
  type        = string
  default     = "10.0.0.0/8"

  validation {
    condition     = can(regex("^(10|172|192)(.[0-9]{1,3}){3}/([8,9]|1[0-9]|2[0-4])$", var.ipam_cidr))
    error_message = "Please specify a valid private CIDR between /8 and /24"
  }
}
