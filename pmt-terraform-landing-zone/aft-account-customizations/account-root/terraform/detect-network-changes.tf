# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

######### Control Tower Events - CT Management #########
resource "aws_cloudwatch_event_rule" "network_change_event_rule" {
  name          = "detect_network_change"
  description   = "A CloudWatch Event Rule that detects changes to network configuration and publishes change events to an SNS topic for notification."
  is_enabled    = true
  event_pattern = <<EOF
{
  "source": ["aws.ec2"],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "ec2:AttachInternetGateway",
      "ec2:AssociateRouteTable",
      "ec2:CreateCustomerGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:DeleteCustomerGateway",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteDhcpOptions",
      "ec2:DetachInternetGateway",
      "ec2:DisassociateRouteTable",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "network_change_event_rule_target" {
  rule      = aws_cloudwatch_event_rule.network_change_event_rule.name
  target_id = "SendToSNS"
  arn       = module.securitynotification_sns_region1.topic_arn
}
