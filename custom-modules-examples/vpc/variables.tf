variable "namespace" {
  description = "Specify a namspace to identify the current deployment in lowercase characters"
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.namespace))
    error_message = "Must be an alphanumeric value with only lowercase characters and a max length of 10"
  }
}

variable "ipam_pool_id" {
  description = "Provide an IPAM Pool ID to use for CIDR assignment"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^$|^ipam-pool-[0-9a-z]{17}$", var.ipam_pool_id))
    error_message = "Must be a valid IPAM Pool ID (^$|^ipam-pool-[0-9a-z]{17}$)"
  }
}

variable "ipam_pool_netmask" {
  description = "Specify the netmask of an IPAM provided CIDR"
  type        = number
  default     = 16

  validation {
    condition     = var.ipam_pool_netmask >= 16 && var.ipam_pool_netmask <= 28
    error_message = "Must be a valid number between 16 and 28"
  }
}

variable "environment" {
  description = "Specify an environment to identify the current deployment in lowercase characters"
  type        = string

  validation {
    condition     = can(regex("[0-9a-z]{1,10}", var.environment))
    error_message = "Must be an alphanumeric value with only lowercase characters and a max length of 10"
  }
}

variable "cidr_block" {
  description = "Please specify a valid VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(regex("^(10|172|192)(.[0-9]{1,3}){3}/(1[6-9]|2[0-4])$", var.cidr_block))
    error_message = "Please specify a valid VPC CIDR between /16 and /24"
  }
}

variable "enable_dns_hostnames" {
  description = "Set to true to enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Set to true to enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Set to true to enable VPC flow logs"
  type        = bool
  default     = true
}

variable "subnet_size_offset" {
  description = "Define the subnet mask offset based on the vpc cidr"
  type        = number
  default     = 8

  validation {
    condition     = var.subnet_size_offset >= 4 && var.subnet_size_offset <= 12
    error_message = "Please specify a valid subnet mask offset size between 4 and 12"
  }
}

variable "target_az_count" {
  description = "Specify the number of Availability Zones to deploy subnets into"
  type        = number
  default     = 3

  validation {
    condition     = var.target_az_count >= 2 && var.target_az_count <= 6
    error_message = "Please specify a valid number of AZs between 2 and 6"
  }
}

variable "tgw_id" {
  description = "If creating a `hub` VPC then you must specify an existing Transit Gateway ID"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^$|^tgw-[0-9a-zA-Z]{17}$", var.tgw_id))
    error_message = "Please specify an empty string or a valid Transit Gateway ID (^$|^tgw-[0-9a-zA-Z]{17}$)"
  }
}

variable "vpc_type" {
  description = "Set to \"hub\" or \"spoke\" to determine if we should create Public Tier or connect to existing TGW. Defaults to \"hub\""
  type        = string
  default     = "hub"

  validation {
    condition     = contains(["spoke", "hub"], var.vpc_type)
    error_message = "Please specify only \"spoke\" or \"hub\""
  }
}

data "aws_availability_zones" "zones" {
  state = "available"
}
