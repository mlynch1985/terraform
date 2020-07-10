resource "aws_ssm_parameter" "parameter" {
    name = "sample-linuxasg-cloudwatchconfig"
    description = "This parameter contains the json config for a Linux Cloudwatch Agent config file"
    type = "String"
    tier = "Standard"
    value = file("${path.module}/ssmparameter.json")
}

resource "aws_cloudwatch_log_group" "logs" {
    name = "amazon-cloudwatch-agent.log"
    retention_in_days = 5
}

resource "aws_cloudwatch_event_rule" "autoscaling_events" {
    name = "sample-linuxasg-autoscaling"
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
    name = "sample-linuxasg-autoscaling"
    tags = {
        Name = "sample-linuxasg-autoscaling"
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
    alarm_name = "sample-linuxasg-highcpu"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPU_USAGE_IDLE"
    namespace = "sample-linuxasg-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 20 # 20% idle or 80% utilized
    alarm_description = "This metric alarm tracks IDLE CPU usage below 20% idle"
    tags = {
        Name = "sample-linuxasg-highcpu"
    }
}

resource "aws_cloudwatch_metric_alarm" "lowdiskspace" {
    alarm_name = "sample-linuxasg-lowdiskspace"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "DISK_FREE"
    namespace = "sample-linuxasg-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 5000000000 # 5GB free space remaining
    alarm_description = "This metric alarm tracks FREE DISK SPACE of 5GB or less"
    tags = {
        Name = "sample-linuxasg-lowdiskspace"
    }
}

resource "aws_cloudwatch_metric_alarm" "highmem" {
    alarm_name = "sample-linuxasg-highmem"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "mem_used"
    namespace = "sample-linuxasg-metrics"
    period = 60 # seconds
    statistic = "Average"
    threshold = 800000000 # 800M used out of 1GB for t3a.micro servers
    alarm_description = "This metric alarm tracks used memory of 800M out of 1GB"
    tags = {
        Name = "sample-linuxasg-highmem"
    }
}
