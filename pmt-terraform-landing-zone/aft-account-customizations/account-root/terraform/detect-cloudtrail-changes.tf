# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

######### Control Tower Events - CT Management #########
resource "aws_cloudwatch_event_rule" "cloudtrail_change_event_rule" {
  name          = "detect_cloudtrail_change"
  description   = "Alarm triggers when CloudTrail is disabled or tampered with."
  is_enabled    = true
  event_pattern = <<EOF
{
  "source": ["aws.cloudtrail"],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ],
    "eventName": [
      "cloudtrail:CreateTrail",
      "cloudtrail:UpdateTrail",
      "cloudtrail:DeleteTrail",
      "cloudtrail:StartLogging",
      "cloudtrail:StopLogging"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "cloudtrail_change_event_rule_target" {
  rule      = aws_cloudwatch_event_rule.cloudtrail_change_event_rule.name
  target_id = "SendToSNS"
  arn       = module.securitynotification_sns_region1.topic_arn
}
