# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "domain" {
  description = "Specify the routing/security domain for this network"
  type        = string
}

variable "ipam_pool_id" {
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  type        = string
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = "$${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr} $${region} $${az-id} $${sublocation-type} $${sublocation-id} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "network_account_id" {
  description = "Provide the Network Account ID"
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

variable "tgw_id" {
  description = "Optionally provide a Transit Gateway ID to create an attachment to this VPC"
  type        = string
}

variable "tgw_default_rtb_id" {
  description = "Provide the ID of the Default VPC TGW Route Table"
  type        = string
}

variable "tgw_inspection_rtb_id" {
  description = "Provide the ID of the Inspection VPC TGW Route Table"
  type        = string
}
