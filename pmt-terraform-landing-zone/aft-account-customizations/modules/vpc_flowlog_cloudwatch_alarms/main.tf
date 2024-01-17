# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# Alarm triggers when >= 10 rejected SSH (port 22) connections are detected in the VPC flow log in a 1 hour period
resource "aws_cloudwatch_metric_alarm" "rejected_ssh" {
  alarm_name          = "rejected_ssh_connections_${var.vpc_name}"
  alarm_description   = "A CloudWatch Alarm that triggers when there are rejected SSH connections in a VPC (Default: 10 connections per hour). Requires VPC flow logs to be enabled."
  metric_name         = "RejectedSSHCount-${var.vpc_name}"
  namespace           = "VPCFlowLogsMetrics"
  statistic           = "Sum"
  period              = "3600"
  threshold           = "10"
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "rejected_ssh" {
  for_each = toset(var.vpc_flowlog_groups)

  log_group_name = each.key
  name           = "RejectedSSHCount-${var.vpc_name}"
  pattern        = "[version, account, eni, source, destination, srcport, destport=\"22\", protocol=\"6\", packets, bytes, windowstart, windowend, action=\"REJECT\", flowlogstatus]"

  metric_transformation {
    default_value = 0
    name          = "RejectedSSHCount-${var.vpc_name}"
    namespace     = "VPCFlowLogsMetrics"
    value         = "1"
  }
}

# Alarm triggers when >= 10 rejected RDP (port 3389) connections are detected in the VPC flow log in a 1 hour period
resource "aws_cloudwatch_metric_alarm" "rejected_rdp" {
  alarm_name          = "rejected_rdp_connections_${var.vpc_name}"
  alarm_description   = "A CloudWatch Alarm that triggers when there are rejected RDP connections in a VPC (Default: 10 connections per hour). Requires VPC flow logs to be enabled."
  metric_name         = "RejectedRDPCount-${var.vpc_name}"
  namespace           = "VPCFlowLogsMetrics"
  statistic           = "Sum"
  period              = "3600"
  threshold           = "10"
  evaluation_periods  = "1"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  alarm_actions       = var.alarm_actions
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_log_metric_filter" "rejected_rdp" {
  for_each = toset(var.vpc_flowlog_groups)

  log_group_name = each.key
  name           = "RejectedRDPCount-${var.vpc_name}"
  pattern        = "[version, account, eni, source, destination, srcport, destport=\"3389\", protocol=\"6\", packets, bytes, windowstart, windowend, action=\"REJECT\", flowlogstatus]"

  metric_transformation {
    default_value = 0
    name          = "RejectedRDPCount-${var.vpc_name}"
    namespace     = "VPCFlowLogsMetrics"
    value         = "1"
  }
}
