resource "aws_ssm_parameter" "parameter" {
    name = "sample-winiis-cloudwatchconfig"
    description = "This parameter contains the json config for a Windows Cloudwatch Agent config file"
    type = "String"
    tier = "Standard"
    value = file("${path.module}/ssmparameter.json")
}

resource "aws_cloudwatch_log_group" "logs" {
    name = "amazon-cloudwatch-agent.log"
    retention_in_days = 5
}

resource "aws_cloudwatch_event_rule" "autoscaling_events" {
    name = "sample-winiis-autoscaling"
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

resource "aws_cloudwatch_event_target" "autoscaling_events" {
    arn = aws_sns_topic.autoscaling_events.arn
    rule = aws_cloudwatch_event_rule.autoscaling_events.name
}

resource "aws_sns_topic" "autoscaling_events" {
    name = "sample-winiis-autoscaling"
    tags = {
        Name = "sample-winiis-autoscaling"
    }
}

data "aws_iam_policy_document" "autoscaling_events" {
    statement {
        effect = "Allow"
        actions = ["SNS:Publish"]
        principals {
            type = "Service"
            identifiers = [
                "events.amazonaws.com",
                "cloudwatch.amazonaws.com"
            ]
        }
        resources = [aws_sns_topic.autoscaling_events.arn]
    }
}

resource "aws_sns_topic_policy" "autoscaling_events" {
    arn = aws_sns_topic.autoscaling_events.arn
    policy = data.aws_iam_policy_document.autoscaling_events.json
}

resource "aws_cloudwatch_metric_alarm" "highcpu" {
    alarm_name = "sample-winiis-highcpu"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPU_IDLE"
    namespace = "sample-winiis-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 20 # 20% idle or 80% utilized
    alarm_description = "This metric alarm tracks IDLE CPU usage below 20% idle"
    tags = {
        Name = "sample-winiis-highcpu"
    }
}

resource "aws_cloudwatch_metric_alarm" "highdiskio" {
    alarm_name = "sample-winiis-highdiskio"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "LogicalDisk % Idle Time"
    namespace = "sample-winiis-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 40 # 40% idle
    alarm_description = "This metric alarm tracks DISK IDLE PERCENTAGE showing busy IO"
    tags = {
        Name = "sample-winiis-highdiskio"
    }
}

resource "aws_cloudwatch_metric_alarm" "highmem" {
    alarm_name = "sample-winiis-highmem"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "Memory Available Bytes"
    namespace = "sample-winiis-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 2000000000 # 2GB memory in use for a t3a.large out of 8GB
    alarm_description = "This metric alarm tracks used memory of 7.5GB out of 8GB"
    tags = {
        Name = "sample-winiis-highmem"
    }
}
