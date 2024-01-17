# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "vpc_id" {
  description = "Provide the VPC ID to enable flow logs for"
  type        = string
}

variable "log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = "$${account-id} $${interface-id} $${srcaddr} $${dstaddr} $${srcport} $${dstport} $${protocol} $${packets} $${bytes} $${start} $${end} $${action} $${log-status} $${vpc-id} $${subnet-id} $${instance-id} $${tcp-flags} $${type} $${pkt-srcaddr} $${pkt-dstaddr} $${region} $${az-id} $${sublocation-type} $${sublocation-id} $${pkt-src-aws-service} $${pkt-dst-aws-service} $${flow-direction} $${traffic-path}"
}
