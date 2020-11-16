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

variable "schedule_name" {
  description = "Specify a name for this maintance window. ex. daily_patching"
  type        = string
  default     = "daily_patching"
}

variable "schedule_cron" {
  description = "Specify a cron expression to define how often this maintenance will execute"
  type        = string
  default     = "cron(0 0 ? * * *)"
}

variable "schedule_timezone" {
  description = "Provide the timezone to schedule"
  type        = string
  default     = "America/New_York"
}

variable "schedule_cutoff" {
  description = "Define the number of hours before the end of the maintenance window to stop execution new tasks"
  type        = number
  default     = 0
}

variable "schedule_duration" {
  description = "Define the number of hours the maintenance window should extend to"
  type        = number
  default     = 4
}

variable "target_tag_name" {
  description = "Specify the tag name used to filter EC2 instances to associate with this maintenance schedule"
  type        = string
  default     = "tag:enable_patching"
}

variable "target_tag_value" {
  description = "Specify the tag value used to filter EC2 instances to associate with this maintenance schedule"
  type        = string
  default     = "true"
}

variable "max_concurrency" {
  description = "Define how many maintenance tasks can be performed in parallel"
  type        = number
  default     = 5
}

variable "max_errors" {
  description = "Define how many errors can be encountered before stopping the maintenance activities"
  type        = number
  default     = 3
}

data "aws_caller_identity" "current" {}
