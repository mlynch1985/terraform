## Define Cloudwatch EC2 Events
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

resource "aws_cloudwatch_event_target" "cw-asg-events-targets" {
    target_id = "sns-topic-asg-events"
    rule = aws_cloudwatch_event_rule.cw-asg-events.name
    arn = aws_sns_topic.sns-topic-asg-events.arn
}
