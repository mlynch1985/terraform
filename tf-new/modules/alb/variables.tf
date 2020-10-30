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

variable "is_internal" {
  description = "Specify whether this is internal or public facing"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "Specify the vpc where this alb should be deployed"
  type        = string
}

variable "security_groups" {
  description = "Provide a list of security groups to apply to elb"
  type        = list(string)
}

variable "subnets" {
  description = "Provide a list of subnets to apply to elb"
  type        = list(string)
}

variable "enable_stickiness" {
  description = "Set to true to enable sticky sessions"
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "Specify the port to poll target group members"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Specify the protocol to poll target group members"
  type        = string
  default     = "HTTP"
}

variable "alb_listener_port" {
  description = "Specify the port the alb will listen on"
  type        = number
  default     = 80
}

variable "alb_listener_protocol" {
  description = "Specify the protocol the alb will use"
  type        = string
  default     = "HTTP"
}

variable "alb_listener_cert" {
  description = "Specify a ssl certificate arn to use for HTTPS protocols"
  type        = string
  default     = ""
}
