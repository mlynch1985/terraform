variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "component" {
  description = "Provide an app role to label each resource within this module"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "is_internal" {
  description = "Specify whether this is internal or public facing"
  type        = bool
  default     = true
}

variable "security_groups" {
  description = "Provide a list of security groups to apply to elb"
  type        = list(string)
}

variable "subnets" {
  description = "Provide a list of subnets to apply to elb"
  type        = list(string)
}
