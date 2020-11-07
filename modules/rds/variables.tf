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

variable "availability_zones" {
  description = "Provide a list of AZs to deploy into"
  type        = list(string)
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)
  default     = []
}

variable "rds_subnets" {
  description = "Provide a list of subnets to deploy EC2 instances into"
  type        = list(string)
}
