# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "domain" {
  description = "Specify the routing/security domain for this network"
  type        = string
}

variable "ram_share_principals" {
  description = "Provide a list of AWS Organizations ARNs to share the Route53 Resolver Rules with"
  type        = list(string)
  default     = []
}

variable "sg_inbound_source_cidrs" {
  description = "Provide a list of IPv4 CIDRs to allow access to Route53 Resolvers"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "sg_outbound_source_cidrs" {
  description = "Provide a list of IPv4 CIDRs to allow access to Route53 Resolvers"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "subnet_ids" {
  description = "Provide list of Subnet IDs to provision the VPC Endpoints inside"
  type        = list(string)
}

variable "vpc_id" {
  description = "Specify the VPC ID to create the VPC Endpoint inside"
  type        = string
}

variable "vpc_endpoints" {
  description = "Provide list of AWS VPC Endpoint names to be configured"
  type        = list(string)
}
