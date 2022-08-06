variable "is_internal" {
  description = "Set to true to create an internal load balancer"
  type        = bool
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

variable "name" {
  description = "Specify the ELB name prefix"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-zA-Z-_]{1,64}$", var.name))
    error_message = "Please specify a valid load balancer name"
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

variable "bucket_name" {
  description = "Please specify a S3 Bucket Name to receive access logs"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^$|^[a-z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Must be a valid S3 Bucket Name (^[a-z0-9.-]{3,63}$)"
  }
}

variable "drop_invalid_header_fields" {
  description = "Set to true to drop invalid headers for ALBs only"
  type        = bool
  default     = true
}

variable "enable_access_logs" {
  description = "Set to true to enable access logs to sent to the S3 bucket"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Set to true to enable cross zone load balancing for NLBs only"
  type        = bool
  default     = true
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

variable "listeners" {
  description = "Specify a list of listener maps to create"
  type = list(object({
    certificate_arn   = string
    listener_port     = number
    listener_protocol = string
    ssl_policy        = string

    default_action = object({
      action_type = string

      fixed_response = list(object({
        content_type      = string
        fixed_status_code = number
        message_body      = string
      }))

      forward = list(object({
        enable_stickiness   = bool
        stickiness_duration = number
        target_group_arn    = any
        target_group_weight = number
      }))

      redirect = list(object({
        redirect_host        = string
        redirect_path        = string
        redirect_port        = number
        redirect_protocol    = string
        redirect_status_code = string
      }))
    })
  }))
  default = []
}

variable "security_groups" {
  description = "Provide a list of security group IDs to attach to an ALB"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for group_id in var.security_groups : can(regex("^$|^sg-[0-9a-zA-Z]{17}$", group_id))
    ])
    error_message = "Please specify a list of valid Security Group ID (^$|^sg-[0-9a-zA-Z]{17}$)"
  }
}
