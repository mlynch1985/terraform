# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "alarm_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
}

variable "vpc_flowlog_groups" {
  type        = list(string)
  description = "List of VPC Flow Log CloudWatch Log Group names to associate the metric filter with."
}

variable "vpc_name" {
  type        = string
  description = "Name of the monitored VPC"
}
