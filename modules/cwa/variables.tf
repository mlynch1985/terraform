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

variable "linux_config" {
  description = "Provide the path to the Linux CWA config json file"
  type        = string
  default     = ""
}

variable "windows_config" {
  description = "Provide the path to the Windows CWA config json file"
  type        = string
  default     = ""
}

variable "auto_scaling_group_name" {
  description = "Provide the friendly name of the AutoScalingGroup to monitor"
  type        = string
}
