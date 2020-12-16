/* ##### ALL REQUIRED VARIABLES ##### */
variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "component" {
  description = "Provide an application role to label each resource within this module"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs to launch instances in"
  type        = list(string)
}

variable "image_id" {
  description = "Specify the AMI ID of the image to be used for each EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Specify the EC2 instance size"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "Provide a list of security group IDs to attach to this instance"
  type        = list(string)
}

/* ##### ASG REQUIRED VARIABLES ##### */
variable "min_size" {
  description = "The minimum size of the auto scaling group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "The maximum size of the auto scaling group"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "The desired capacity of the auto scaling group"
  type        = number
  default     = 1
}

variable "capacity_rebalance" {
  description = "Allows to the capacity to be balanced across the AZs"
  type        = bool
  default     = false
}

variable "default_cooldown" {
  description = "The amoung of time in seconds between scaling events"
  type        = number
  default     = null
}

variable "healthcheck_grace_period" {
  description = "Time in seconds after instance launch before performing healthchecks"
  type        = number
  default     = 300
}

variable "healthcheck_type" {
  description = "Specify EC2 or ELB to determine how healthchecks should be performed"
  type        = string
  default     = "EC2"
}

variable "force_delete" {
  description = "Allow ASG to terminate before all instances have been terminated"
  type        = bool
  default     = false
}

variable "target_group_arns" {
  description = "A list of target group ARNs to associated instances with"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  ## Allowed Values: Default, OldestInstance, NewestInstance, OldestLaunchConfiguration, NewestLaunchConfiguration, ClosestToNextInstanceHour, OldestLaunchTemplate
  description = "A list of policies to decide how instances in ASG should be terminated"
  type        = list(string)
  default     = ["Default"]
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "wait_for_capacity_timeout" {
  description = "Max duration Terraform should wait for instances to be healthy"
  type        = string
  default     = "10m"
}

variable "protect_from_scale_in" {
  description = "Prevents instances from be terminated due to a scale in operation"
  type        = bool
  default     = false
}

# variable "service_linked_role_arn" {
#   description = "Override the default service linked role with a custom role"
#   type        = string
#   default     = ""
# }

/* ##### LAUNCH TEMPLATE REQUIRED VARIABLES ##### */
variable "update_default_version" {
  description = "Set to true to overwrite Default version or false to create a new version"
  type        = bool
  default     = true
}

variable "block_device_mappings" {
  description = "Specify a list of block device mappings to attach to each instance"
  type        = any
  default     = []
}

variable "disable_api_termination" {
  description = "Set to true to prevent termination of instance via API calls"
  type        = bool
  default     = false
}

variable "iam_instance_profile" {
  description = "Please specify the iam instance profile arn to attach to each EC2 instance"
  type        = any
  default     = null
}

variable "key_name" {
  description = "Specify the key name to attach and allow access to each EC2 instance"
  type        = string
  default     = ""
}

variable "monitoring" {
  description = "Set to true to enable detailed monitoring at 1 minute intervals"
  type        = bool
  default     = false
}

variable "user_data" {
  description = "Specify a path to a userdata script"
  type        = string
  default     = ""
}
