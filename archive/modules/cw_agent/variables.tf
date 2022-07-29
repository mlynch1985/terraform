variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "component" {
  description = "Provide an application role to label each resource within this module"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "iam_role_name" {
  description = "Provide the EC2 Instance Role Name to attach the CloudWatchServerAgent policy to"
  type        = string
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
