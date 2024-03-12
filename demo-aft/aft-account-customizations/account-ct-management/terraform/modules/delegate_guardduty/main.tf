# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_guardduty_detector" "region1" {
  #checkov:skip=CKV2_AWS_3:Ensure GuardDuty is enabled to specific org/region (This is a false positive)
  provider = aws.region1

  tags = {
    # AMAZON_GUARDDUTY-1:GUARDDUTY_ENABLED_CENTRALIZED:CT-Management account needs to delegate to Audit account
    "opa_skip" = "AMAZON_GUARDDUTY-1"
  }
}

resource "aws_guardduty_detector" "region2" {
  #checkov:skip=CKV2_AWS_3:Ensure GuardDuty is enabled to specific org/region (This is a false positive)
  depends_on = [aws_guardduty_detector.region1]
  provider   = aws.region2

  tags = {
    # AMAZON_GUARDDUTY-1:GUARDDUTY_ENABLED_CENTRALIZED:CT-Management account needs to delegate to Audit account
    "opa_skip" = "AMAZON_GUARDDUTY-1"
  }
}

resource "aws_guardduty_detector" "region3" {
  #checkov:skip=CKV2_AWS_3:Ensure GuardDuty is enabled to specific org/region (This is a false positive)
  depends_on = [aws_guardduty_detector.region2]
  provider   = aws.region3

  tags = {
    # AMAZON_GUARDDUTY-1:GUARDDUTY_ENABLED_CENTRALIZED:CT-Management account needs to delegate to Audit account
    "opa_skip" = "AMAZON_GUARDDUTY-1"
  }
}

resource "aws_guardduty_detector" "region4" {
  #checkov:skip=CKV2_AWS_3:Ensure GuardDuty is enabled to specific org/region (This is a false positive)
  depends_on = [aws_guardduty_detector.region3]
  provider   = aws.region4

  tags = {
    # AMAZON_GUARDDUTY-1:GUARDDUTY_ENABLED_CENTRALIZED:CT-Management account needs to delegate to Audit account
    "opa_skip" = "AMAZON_GUARDDUTY-1"
  }
}

resource "aws_guardduty_organization_admin_account" "region1" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_guardduty_detector.region4]
  provider         = aws.region1
}

resource "aws_guardduty_organization_admin_account" "region2" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_guardduty_organization_admin_account.region1]
  provider         = aws.region2
}

resource "aws_guardduty_organization_admin_account" "region3" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_guardduty_organization_admin_account.region2]
  provider         = aws.region3
}

resource "aws_guardduty_organization_admin_account" "region4" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_guardduty_organization_admin_account.region3]
  provider         = aws.region4
}
