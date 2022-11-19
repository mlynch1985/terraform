locals {
  az_index = ["a", "b", "c", "d", "e", "f"]
}

data "aws_availability_zones" "zones" {
  state = "available"
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

variable "subnet_size_offset" {
  description = "Define the subnet mask offset based on the VPC CIDR"
  type        = number
  default     = 4

  validation {
    condition     = var.subnet_size_offset >= 4 && var.subnet_size_offset <= 12
    error_message = "Please specify a valid subnet mask offset size between 4 and 12"
  }
}

variable "target_az_count" {
  description = "Specify the number of availability zones to deploy subnets into"
  type        = number
  default     = 4

  validation {
    condition     = var.target_az_count >= 2 && var.target_az_count <= 6
    error_message = "Please specify a valid number of AZs between 2 and 6"
  }
}

variable "tgw_cidr" {
  description = "Specify the CIDR for TGW Routing"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^(10|172|192)(.[0-9]{1,3}){3}/([8,9]|1[0-9]|2[0-4])$", var.tgw_cidr))
    error_message = "Please specify a valid IP CIDR for the Transit Gateway Network"
  }
}
