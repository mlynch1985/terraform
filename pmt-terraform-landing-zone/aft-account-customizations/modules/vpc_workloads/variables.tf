# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_ec2_transit_gateway" "this" {
  filter {
    name   = "options.amazon-side-asn"
    values = [var.tgw_asn]
  }
  filter {
    name   = "owner-id"
    values = [var.network_account_id]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  type        = string
}

variable "network_account_id" {
  description = "Provide the Network Account ID to help filter and attach to"
  type        = string
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets"
  type        = list(string)
}

variable "transit_subnet_names" {
  description = "Explicit values to use in the Name tag on transit subnets"
  type        = list(string)
}

variable "tgw_asn" {
  description = "Provide a Transit Gateway ASN to help filter and attach to"
  type        = string
}

variable "auto_enable_tgw_route" {
  description = "Specify whether or not to automatically create a return route on the Inspection TGW Route Table to this VPC"
  type        = bool
  default     = true
}
