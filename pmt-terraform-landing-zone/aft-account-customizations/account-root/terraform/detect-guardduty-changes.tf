# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

######### Control Tower Events - CT Management #########
resource "aws_cloudwatch_event_rule" "guard_duty_change_event_rule" {
  name          = "detect_guard_duty_change"
  description   = "Alarm triggers when Guard duty is disabled or tampered with."
  is_enabled    = true
  event_pattern = <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "guardduty.amazonaws.com"
    ],
    "eventName": [
      "guardduty:AcceptInvitation",
      "guardduty:ArchiveFindings",
      "guardduty:CreateDetector",
      "guardduty:CreateFilter",
      "guardduty:CreateIPSet",
      "guardduty:CreateMembers",
      "guardduty:CreatePublishingDestination",
      "guardduty:CreateSampleFindings",
      "guardduty:CreateThreatIntelSet",
      "guardduty:DeclineInvitations",
      "guardduty:DeleteDetector",
      "guardduty:DeleteFilter",
      "guardduty:DeleteInvitations",
      "guardduty:DeleteIPSet",
      "guardduty:DeleteMembers",
      "guardduty:DeletePublishingDestination",
      "guardduty:DeleteThreatIntelSet",
      "guardduty:DisassociateFromMasterAccount",
      "guardduty:DisassociateMembers",
      "guardduty:InviteMembers",
      "guardduty:StartMonitoringMembers",
      "guardduty:StopMonitoringMembers",
      "guardduty:TagResource",
      "guardduty:UnarchiveFindings",
      "guardduty:UntagResource",
      "guardduty:UpdateDetector",
      "guardduty:UpdateFilter",
      "guardduty:UpdateFindingsFeedback",
      "guardduty:UpdateIPSet",
      "guardduty:UpdatePublishingDestination",
      "guardduty:UpdateThreatIntelSet"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "guard_duty_change_event_rule_target" {
  rule      = aws_cloudwatch_event_rule.guard_duty_change_event_rule.name
  target_id = "SendToSNS"
  arn       = module.securitynotification_sns_region1.topic_arn
}
