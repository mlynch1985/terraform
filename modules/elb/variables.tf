/* ##### REQUIRED VARIABLES ##### */
variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "component" {
  description = "Provide an app role to label each resource within this module"
  type        = string
}

variable "load_balancer_type" {
  description = "Specify either application or network"
  type        = string
}

variable "subnets" {
  description = "Provide a list of subnets to apply to elb"
  type        = list(string)
}

/* ##### ALB VARIABLES ##### */
variable "security_groups" {
  description = "Provide a list of security groups to apply to elb"
  type        = list(string)
  default     = []
}

variable "drop_invalid_header_fields" {
  description = "Remove HTTP headers with invalid fields"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Time in seconds connections can be idle"
  type        = number
  default     = 60
}

variable "enable_http2" {
  description = "Enables HTTP/2 traffic on ALB"
  type        = bool
  default     = true
}


/* ##### NLB VARIABLES ##### */
variable "enable_cross_zone_load_balancing" {
  description = "Allows NLB to distribute traffic across AZs"
  type        = bool
  default     = false
}


/* ##### OPTIONAL VARIABLES ##### */
variable "internal" {
  description = "Specify whether this is internal or public facing"
  type        = bool
  default     = true
}

variable "enable_deletion_protection" {
  description = "Prevents termination using API calls"
  type        = bool
  default     = false
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
