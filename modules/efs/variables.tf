variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "name" {
  description = "Provide a name to label each resource within this module"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "is_encrypted" {
  description = "Set to true to encrypt the EFS volume"
  type        = bool
  default     = false
}

variable "performance_mode" {
  description = "Set to either generalPurpose or maxIO"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "Set to either bursting or provisioned"
  type        = string
  default     = "bursting"
}

variable "throughput_mibps" {
  description = "Set to required number of mibps"
  type        = number
  default     = 50
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to the mount points"
  type        = list(string)
  default     = []
}

variable "subnets" {
  description = "Provide the subnet ID deploy EFS mount point into"
  type        = list(string)
}
