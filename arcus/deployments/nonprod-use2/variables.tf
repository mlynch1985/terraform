data "aws_caller_identity" "current" {}

variable "region" {
  description = "Specify the AWS region to deploy resources into"
  type        = string

  validation {
    condition     = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be a valid AWS Region name"
  }
}

variable "az_zone_ids" {
  description = "Specify the Zone ID of each availability zone to deploy subnets into"
  type        = list(string)
}

variable "cidr_block" {
  description = "Please specify a valid VPC CIDR"
  type        = string

  validation {
    condition     = can(regex("^$|^(10|172|192)(.[0-9]{1,3}){3}/(1[6-9]|2[0-6])$", var.cidr_block))
    error_message = "Please specify a valid VPC CIDR between /16 and /26"
  }
}
