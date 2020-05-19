## Define our SNS Topic to capture Cloudwatch Events and Alarms
resource "aws_sns_topic" "sns-topic-asg-events" {
  name = "${var.namespace}-asg-events"
  tags = {
    Name        = "${var.namespace}-sns-topic-asg-events"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define the SNS Topic Policy
resource "aws_sns_topic_policy" "sns-policy-asg-events" {
  arn    = aws_sns_topic.sns-topic-asg-events.arn
  policy = data.aws_iam_policy_document.sns-iam-asg-events.json
}

## Define the SNS Topic Policy IAM Role
data "aws_iam_policy_document" "sns-iam-asg-events" {
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

    resources = ["${aws_sns_topic.sns-topic-asg-events.arn}"]
  }
}
