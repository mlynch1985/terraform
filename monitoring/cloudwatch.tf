## Create Cloudwatch LogGroup for WindowsEvent Logs
resource "aws_cloudwatch_log_group" "windows_eventlogs" {
  name              = "${var.namespace}_windows_eventlogs"
  retention_in_days = 14

  tags = {
    Name        = "${var.namespace}_windows_eventlogs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Cloudwatch LogGroup for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "${var.namespace}_vpc_flow_logs"
  retention_in_days = 14

  tags = {
    Name        = "${var.namespace}_vpc_flow_logs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Cloudwatch LogGroup for CloudwatchAgent Logs
resource "aws_cloudwatch_log_group" "cloudwatch_agent_logs" {
  name              = "amazon-cloudwatch-agent.log"
  retention_in_days = 14

  tags = {
    Name        = "${var.namespace}_cloudwatch_agent_logs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Alert on AutoScaling Events and send to SNS Topic
resource "aws_cloudwatch_event_rule" "autoscaling_events" {
  name        = "${var.namespace}_autoscaling_events"
  description = "Notify for AutoScaling Event"

  event_pattern = <<EOF
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful",
    "EC2 Instance Terminate Successful",
    "EC2 Instance Launch Unsuccessful",
    "EC2 Instance Terminate Unsuccessful",
    "EC2 Instance-launch Lifecycle Action",
    "EC2 Instance-terminate Lifecycle Action"
  ]
}
EOF
}

## Define which SNS Topic to push to
resource "aws_cloudwatch_event_target" "autoscaling_events" {
  target_id = "${var.namespace}_autoscaling_events"
  rule      = aws_cloudwatch_event_rule.autoscaling_events.name
  arn       = aws_sns_topic.autoscaling_events.arn
}

## Create Metric Alarm for High CPU
resource "aws_cloudwatch_metric_alarm" "alarm_ec2_highcpu" {
  alarm_name          = "${var.namespace}_ec2_highcpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPU_USAGE_IDLE"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_cloudwatch_event_target.autoscaling_events.arn}"]

  tags = {
    Name        = "${var.namespace}_ec2_highcpu"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Metric Alarm for Disk Space
resource "aws_cloudwatch_metric_alarm" "alarm_ec2_diskspace" {
  alarm_name          = "${var.namespace}_ec2_diskspace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DISK_FREE"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "5000000000" ## 5 GB
  alarm_description   = "This metric monitors ec2 free disk space"
  alarm_actions       = ["${aws_cloudwatch_event_target.autoscaling_events.arn}"]

  tags = {
    Name        = "${var.namespace}_ec2_diskspace"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
