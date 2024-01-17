# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets"
  type        = list(string)
}

variable "transit_subnet_names" {
  description = "Explicit values to use in the Name tag on transit subnets"
  type        = list(string)
}

variable "tgw_cidr_route" {
  description = "Specify the cidr to direct traffic meant for the transit gateway"
  type        = string
}

variable "tgw_id" {
  description = "Optionally provide a Transit Gateway ID to create an attachment to this VPC"
  type        = string
}
