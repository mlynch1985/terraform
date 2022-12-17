variable "enable_lifecycle_policy" {
  description = "Set to true to enable an EFS lifecycle policy"
  type        = bool
  default     = "false"
}

variable "iam_roles" {
  description = "Please specify a list of IAM Role to be granted access to the EFS Share"
  type        = list(string)

  validation {
    condition = alltrue([
      for role in var.iam_roles : can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9-_./]{1,96}$", role))
    ])
    error_message = "Please specify a list of valid IAM Role ARNs"
  }
}

variable "kms_key_arn" {
  description = "Please specify the KMS Key ARN to encrypt the file system"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$", var.kms_key_arn))
    error_message = "Please specify a valid KMS Key ARN (^arn:aws:kms:[a-z][a-z]-[a-z]+-[1-9]:[0-9]{12}:key/[a-zA-Z0-9-]{36}$)"
  }
}

variable "performance_mode" {
  description = "Specify the EFS File System performance mode"
  type        = string
  default     = "generalPurpose"

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Specify a valid EFS File System performance mode"
  }
}

variable "provisioned_throughput" {
  description = "Specify the desired amount in MIBs of throughput"
  type        = number
  default     = 125

  validation {
    condition     = var.provisioned_throughput >= 1 && var.provisioned_throughput <= 1024
    error_message = "Specify the desired amount in MIBs of throughput between 1 and 1024"
  }
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to the EFS share"
  type        = list(string)

  validation {
    condition = alltrue([
      for group_id in var.security_groups : can(regex("^sg-[0-9a-zA-Z]{17}$", group_id))
    ])
    error_message = "Please specify a list containing at least one valid Security Group ID (^sg-[0-9a-zA-Z]{17}$)"
  }
}

variable "subnets" {
  description = "Specify a list of subnet IDs to create mount targets in"
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(regex("^subnet-[0-9a-zA-Z]{17}$", subnet))
    ])
    error_message = "Please specify a list containing at least one valid Subnet ID (^subnet-[0-9a-zA-Z]{17}$)"
  }
}

variable "throughput_mode" {
  description = "Specify the EFS File System throughput mode"
  type        = string
  default     = "elastic"

  validation {
    condition     = contains(["bursting", "elastic", "provisioned"], var.throughput_mode)
    error_message = "Specify a valid EFS File System throughput mode"
  }
}
