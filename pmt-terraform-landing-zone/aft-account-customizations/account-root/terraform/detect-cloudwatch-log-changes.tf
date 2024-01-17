# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

######### Control Tower Events - CT Management #########
resource "aws_cloudwatch_event_rule" "cloudwatch_log_change_event_rule" {
  name          = "detect_cloudwatch_log_change"
  description   = "Alarm triggers when CloudWatch Log is disabled or tampered with."
  is_enabled    = true
  event_pattern = <<EOF
{
  "source": ["aws.logs"],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "logs.amazonaws.com"
    ],
    "eventName": [
      "logs:DeleteDestination",
      "logs:DeleteLogGroup",
      "logs:DeleteLogStream",
      "logs:DeleteMetricFilter",
      "logs:DeleteQueryDefinition",
      "logs:DeleteResourcePolicy",
      "logs:DeleteRetentionPolicy",
      "logs:DeleteSubscriptionFilter",
      "logs:DeleteDataProtectionPolicy"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "cloudwatch_log_change_event_rule_target" {
  rule      = aws_cloudwatch_event_rule.cloudwatch_log_change_event_rule.name
  target_id = "SendToSNS"
  arn       = module.securitynotification_sns_region1.topic_arn
}
