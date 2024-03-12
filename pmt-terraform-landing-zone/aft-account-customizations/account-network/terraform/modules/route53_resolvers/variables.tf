# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "allowed_ip_range" {
  description = "Specify an IPv4 CIDR block to allows DNS port 53 traffic from"
  type        = string
}

variable "domain" {
  description = "Specify the routing/security domain for this network"
  type        = string
}

variable "endpoints_vpc" {
  description = "Provide the VPC object in which to provision these resources"
  type        = any
}

variable "onprem_ips" {
  description = "Provide list of onprem DNS Server IPs to forward queries to"
  type        = list(string)
}

variable "ram_principals" {
  description = "A list of principals to share the resolver rule with. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN"
  type        = list(string)
}
