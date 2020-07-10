resource "aws_cloudwatch_event_rule" "cluster_events" {
    name = "sample-ecs-events"
    description = "Notify for ECS Cluster Events"
    event_pattern = <<EOF
{
    "source": [
        "aws.ecs"
        ],
        "detail-type": [
            "ECS Task State Change",
            "ECS Container Instance State Change"
        ],
        "detail": {
            "clusterArn": [
                "${aws_ecs_cluster.cluster.arn}"
            ]
        }
}
EOF
}

resource "aws_cloudwatch_event_target" "cluster_events" {
    arn = aws_sns_topic.cluster_events.arn
    rule = aws_cloudwatch_event_rule.cluster_events.name
}

resource "aws_sns_topic" "cluster_events" {
    name = "sample-ecs-events"
    tags = {
        Name = "sample-ecs-events"
    }
}

data "aws_iam_policy_document" "cluster_events" {
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
        resources = [aws_sns_topic.cluster_events.arn]
    }
}

resource "aws_sns_topic_policy" "cluster_events" {
    arn = aws_sns_topic.cluster_events.arn
    policy = data.aws_iam_policy_document.cluster_events.json
}

resource "aws_cloudwatch_metric_alarm" "highcpu" {
    alarm_name = "sample-ecs-highcpu"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = 60 # seconds
    statistic = "Average"
    threshold = 80 # 80% Utilization
    alarm_description = "This metric alarm tracks CPU Utilization over 80%"
    tags = {
        Name = "sample-ecs-highcpu"
    }
}

resource "aws_cloudwatch_metric_alarm" "highmem" {
    alarm_name = "sample-ecs-highmem"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = 2
    metric_name = "MemoryUtilization"
    namespace = "AWS/ECS"
    period = 60 # seconds
    statistic = "Average"
    threshold = 80 # 80% Utilization
    alarm_description = "This metric alarm tracks Memory Utilization over 80%"
    tags = {
        Name = "sample-ecs-highmem"
    }
}
