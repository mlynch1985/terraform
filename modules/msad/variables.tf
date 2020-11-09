variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "app_role" {
  description = "Provide an application role to label each resource within this module"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "domain_name" {
  description = "Specify a fully qualified domain name such as corp.example.com"
  type        = string
}

variable "edition" {
  description = "Specify either Standard or Enterprise for the edition of AD to deploy."
  type        = string
  default     = "Standard"
}

variable "enable_sso" {
  description = "Set to true to enable single-sign on for this directory"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "Specify the target VPC ID to deploy into"
  type        = string
}

variable "subnet_1" {
  description = "Provide a subnet ID to deploy EC2 instances into"
  type        = string
}

variable "subnet_2" {
  description = "Provide a subnet ID to deploy EC2 instances into"
  type        = string
}

variable "enable_auto_join" {
  description = "Set to true to create an SSM Association that will auto-join instances to AD"
  type        = bool
  default     = false
}

variable "ad_target_tag_name" {
  description = "Specify the target TAG name used for auto-join"
  type        = string
  default     = "namespace"
}

variable "ad_target_tag_value" {
  description = "Specify the target TAG value used for auto-join"
  type        = string
  default     = ""
}
