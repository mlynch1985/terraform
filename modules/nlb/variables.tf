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

variable "subnets" {
  description = "Provide a list of subnets to apply to elb"
  type        = list(string)
}

variable "enable_cross_zone_load_balancing" {
  description = "Set to true to allow NLB to talk across availability zones"
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

variable "vpc_id" {
  description = "Specify the vpc where this nlb should be deployed"
  type        = string
}

variable "deregistration_delay" {
  description = "Specify how long an instance should drain before removing from nlb"
  type        = number
  default     = 300
}

variable "enable_stickiness" {
  description = "Set to true to enable sticky sessions"
  type        = bool
  default     = false
}

variable "healthcheck_path" {
  description = "Specify the url path to perform a healthcheck on target instances"
  type        = string
  default     = "/"
}

variable "nlb_listener_port" {
  description = "Specify the port the nlb will listen on"
  type        = number
  default     = 80
}

variable "nlb_listener_protocol" {
  description = "Specify the protocol the nlb will use"
  type        = string
  default     = "HTTP"
}

variable "nlb_listener_cert" {
  description = "Specify a ssl certificate arn to use for HTTPS protocols"
  type        = string
  default     = ""
}
