# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_macie2_account" "region1" {
  provider = aws.region1
}

resource "aws_macie2_account" "region2" {
  depends_on = [aws_macie2_account.region1]
  provider   = aws.region2
}

resource "aws_macie2_account" "region3" {
  depends_on = [aws_macie2_account.region2]
  provider   = aws.region3
}

resource "aws_macie2_account" "region4" {
  depends_on = [aws_macie2_account.region3]
  provider   = aws.region4
}

resource "aws_macie2_organization_admin_account" "region1" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_macie2_account.region4]
  provider         = aws.region1
}

resource "aws_macie2_organization_admin_account" "region2" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_macie2_organization_admin_account.region1]
  provider         = aws.region2
}

resource "aws_macie2_organization_admin_account" "region3" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_macie2_organization_admin_account.region2]
  provider         = aws.region3
}

resource "aws_macie2_organization_admin_account" "region4" {
  admin_account_id = var.target_account_id
  depends_on       = [aws_macie2_organization_admin_account.region3]
  provider         = aws.region4
}
