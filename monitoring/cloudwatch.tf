## Alert on AutoScaling Events and send to SNS Topic
resource "aws_cloudwatch_event_rule" "cw-asg-events" {
  name        = "${var.namespace}-cw-asg-events"
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
resource "aws_cloudwatch_event_target" "cw-asg-events-targets" {
  target_id = "sns-topic-asg-events"
  rule      = aws_cloudwatch_event_rule.cw-asg-events.name
  arn       = aws_sns_topic.sns-topic-asg-events.arn
}

## Create Metric Alarm for High CPU
resource "aws_cloudwatch_metric_alarm" "cw-alarm-ec2-highcpu" {
  alarm_name          = "${var.namespace}-ec2-high-cpu"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPU_USAGE_IDLE"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "20"
  alarm_description   = "This metric monitors ec2 cpu utilization"
  alarm_actions       = ["${aws_cloudwatch_event_target.cw-asg-events-targets.arn}"]

  tags = {
    Name        = "${var.namespace}-cw-alarm-ec2-highcpu"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Metric Alarm for Disk Space
resource "aws_cloudwatch_metric_alarm" "cw-alarm-ec2-diskspace" {
  alarm_name          = "${var.namespace}-ec2-disk-space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DISK_FREE"
  namespace           = "CWAgent"
  period              = "60"
  statistic           = "Average"
  threshold           = "5000000000" ## 5 GB
  alarm_description   = "This metric monitors ec2 free disk space"
  alarm_actions       = ["${aws_cloudwatch_event_target.cw-asg-events-targets.arn}"]

  tags = {
    Name        = "${var.namespace}-cw-alarm-ec2-diskspace"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
