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

variable "platform" {
  description = "Specify either windows or linux"
  type        = string
}

variable "config_json" {
  description = "Provide the path to the CWA config json file"
  type        = string
}
