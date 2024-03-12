# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "alarm_actions" {
  type        = list(string)
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state. Each action is specified as an Amazon Resource Name (ARN)."
}

variable "alarm_description" {
  type        = string
  description = "Alarm Description"
}

variable "filter_pattern" {
  type        = string
  description = "A valid CloudWatch Logs filter pattern for extracting metric data out of ingested log events."
}

variable "log_group_name" {
  type        = string
  description = "The cloudtrail cloudwatch log group name."
}

variable "metric_name" {
  type        = string
  description = "A name for the metric filter"
}

variable "metric_namespace" {
  description = "A namespace for grouping all of the metrics together."
  default     = "CloudTrailMetrics"
}

variable "period" {
  type        = number
  description = "The period in seconds over which the specified statistic is applied."
  default     = 60
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
