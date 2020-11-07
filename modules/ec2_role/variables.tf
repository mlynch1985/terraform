variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Provide a name to label each resource within this module"
  type        = string
}

variable "path" {
  description = "Define the path this role should exist"
  type        = string
  default     = "/"
}

variable "description" {
  description = "Give a description for this role"
  type        = string
  default     = "EC2 role created by Terraform"
}

variable "max_session_duration" {
  description = "Provide a name to label each resource within this module"
  type        = number
  default     = 3600
}

