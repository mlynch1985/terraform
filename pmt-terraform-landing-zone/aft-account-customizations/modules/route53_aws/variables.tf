# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "account_zone_id" {
  description = "Provide the local account Route53 Private Hosted Zone ID"
  type        = string
}

variable "account_vpc_id" {
  description = "Provide the local account VPC ID"
  type        = string
}

variable "domain" {
  description = "Specify the routing/security domain for this network"
  type        = string
}

variable "parent_domain_name" {
  description = "Specify the DNS name of the parent Route53 PHZ"
  type        = string
}

variable "parent_vpc_name" {
  description = "Specify the VPC Name tag value of the parent shared_services VPC"
  type        = string
}
