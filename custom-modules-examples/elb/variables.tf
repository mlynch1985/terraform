variable "bucket_name" {
  description = "Please specify a S3 Bucket Name to receive access logs"
  type        = string
  default     = null

  validation {
    condition     = var.bucket_name == null || can(regex("^$|^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "drop_invalid_header_fields" {
  description = "Set to true to drop invalid headers for ALBs only"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Set to true to enable cross zone load balancing for NLBs only"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Specify the amount of seconds before timing out idle connections"
  type        = number
  default     = 60

  validation {
    condition     = var.idle_timeout >= 10 && var.idle_timeout <= 300
    error_message = "Must be a valid number between 10 and 300"
  }
}

variable "is_internal" {
  description = "Set to true to create an internal load balancer"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Please specify the type of load balancer to deploy"
  type        = string

  validation {
    condition = contains([
      "application", "network", "gateway"
    ], var.lb_type)
    error_message = "Please specify a valid ELB type: \"application\", \"network\", \"gateway\""
  }
}

variable "listeners" {
  description = "Specify a list of listener maps to create"
  type = map(object({
    alpn_policy       = string
    certificate_arn   = string
    listener_port     = number
    listener_protocol = string
    ssl_policy        = string

    default_action = object({
      action_type = string

      fixed_response = list(object({
        content_type      = string
        message_body      = string
        fixed_status_code = number
      }))

      forward = list(object({
        target_group_arn    = any
        stickiness_duration = number
        enable_stickiness   = bool
      }))

      redirect = list(object({
        redirect_status_code = string
        redirect_host        = string
        redirect_path        = string
        redirect_port        = number
        redirect_protocol    = string
      }))
    })
  }))
  default = {}
}

variable "name_tag" {
  description = "Specify the tag value for the Name tag"
  type        = string
  defualt     = null

  validation {
    condition     = var.name_tag == null || can(regex("^[0-9a-zA-Z-_]{1,64}$", var.name_tag))
    error_message = "Please specify a valid name to tag the ELB with"
  }
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to an ALB"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for group_id in var.security_groups : can(regex("^$|^sg-[0-9a-zA-Z]{17}$", group_id))
    ])
    error_message = "Please specify a list of valid Security Group IDs (^$|^sg-[0-9a-zA-Z]{17}$)"
  }
}

variable "subnets" {
  description = "List of subnet IDs to deploy the ELB into"
  type        = list(string)

  validation {
    condition = alltrue([
      for subnet in var.subnets : can(regex("^subnet-[0-9a-zA-Z]{17}$", subnet))
    ])
    error_message = "Please specify a list containing at least one valid Subnet ID (^subnet-[0-9a-zA-Z]{17}$)"
  }
}
