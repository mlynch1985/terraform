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

variable "target_ids" {
  description = "Provide a list of EC2 Instance IDs to add to our target_group"
  type        = list(string)
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
  description = "Specify the vpc where this elb should be deployed"
  type        = string
}

variable "deregistration_delay" {
  description = "Specify how long an instance should drain before removing from elb"
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

variable "elb_arn" {
  description = "Provide the elb resource to associate with the listener"
  type        = string
}

variable "elb_type" {
  description = "Select either ALB or NLB for the type of load balancer to attach to"
  type        = string
}

variable "elb_listener_port" {
  description = "Specify the port the elb will listen on"
  type        = number
  default     = 80
}

variable "elb_listener_protocol" {
  description = "Specify the protocol the elb will use"
  type        = string
  default     = "HTTP"
}

variable "elb_listener_cert" {
  description = "Specify a ssl certificate arn to use for HTTPS protocols"
  type        = string
  default     = ""
}
