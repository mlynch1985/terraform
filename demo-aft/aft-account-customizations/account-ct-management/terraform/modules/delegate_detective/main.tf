# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_detective_organization_admin_account" "region1" {
  account_id = var.target_account_id
  provider   = aws.region1
}

resource "aws_detective_organization_admin_account" "region2" {
  account_id = var.target_account_id
  depends_on = [aws_detective_organization_admin_account.region1]
  provider   = aws.region2
}

resource "aws_detective_organization_admin_account" "region3" {
  account_id = var.target_account_id
  depends_on = [aws_detective_organization_admin_account.region2]
  provider   = aws.region3
}

resource "aws_detective_organization_admin_account" "region4" {
  account_id = var.target_account_id
  depends_on = [aws_detective_organization_admin_account.region3]
  provider   = aws.region4
}
