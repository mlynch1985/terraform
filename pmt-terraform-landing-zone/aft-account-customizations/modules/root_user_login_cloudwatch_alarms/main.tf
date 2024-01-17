# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_cloudwatch_metric_alarm" "CloudWatchAlarm" {
  alarm_name          = "${var.metric_name}-alarm"
  alarm_description   = var.alarm_description
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  statistic           = "Sum"
  period              = "60"
  threshold           = "1"
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"
  tags                = merge({ Name = "${var.metric_name}-alarm" }, var.tags)
}

resource "aws_cloudwatch_log_metric_filter" "MetricFilter" {
  name           = var.metric_name
  log_group_name = var.log_group_name
  pattern        = var.filter_pattern

  metric_transformation {
    name      = var.metric_name
    value     = "1"
    namespace = var.metric_namespace
  }

}
