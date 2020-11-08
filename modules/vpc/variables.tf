variable "namespace" {
  description = "Specify a stack namespace to prefix all resources"
  type        = string
}

variable "default_tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "The CIDR block for the VPC.  Should be a valid CIDR between /16 and /28"
  type        = string
  default     = "10.0.0.0/16"
}

variable "enable_dns_support" {
  description = "Set to true to enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Set to true to enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

variable "target_az_count" {
  description = "Specify the number of Availability Zones to deploy subnets into"
  type        = number
  default     = 3
}

variable "deploy_private_subnets" {
  description = "Set to true to create private subnets with route to nat gateways"
  type        = bool
  default     = false
}

variable "deploy_protected_subnets" {
  description = "Set to true to create protected subnets with no internet access"
  type        = bool
  default     = false
}

variable "enable_flow_logs" {
  description = "Set to true to enable VPC flow logs"
  type        = bool
  default     = false
}

data "aws_availability_zones" "zones" {
  state = "available"
}
