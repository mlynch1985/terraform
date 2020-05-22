## Define our SNS Topic to capture Cloudwatch Events and Alarms
resource "aws_sns_topic" "autoscaling_events" {
  name = "${var.namespace}-autoscaling_events"
  tags = {
    Name        = "${var.namespace}-autoscaling_events"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define the SNS Topic Policy
resource "aws_sns_topic_policy" "autoscaling_events" {
  arn    = aws_sns_topic.autoscaling_events.arn
  policy = data.aws_iam_policy_document.autoscaling_events.json
}

## Define the SNS Topic Policy IAM Role
data "aws_iam_policy_document" "autoscaling_events" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = [
        "events.amazonaws.com",
        "cloudwatch.amazonaws.com"
      ]
    }

    resources = ["${aws_sns_topic.autoscaling_events.arn}"]
  }
}
