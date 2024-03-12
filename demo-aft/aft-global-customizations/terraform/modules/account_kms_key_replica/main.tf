# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_kms_replica_key" "region2" {
  description             = "Multi-Region replica key"
  deletion_window_in_days = 30
  primary_key_arn         = var.primary_kms_key_arn
  provider                = aws.region2
}

resource "aws_kms_replica_key" "region3" {
  description             = "Multi-Region replica key"
  deletion_window_in_days = 30
  primary_key_arn         = var.primary_kms_key_arn
  provider                = aws.region3
}

resource "aws_kms_replica_key" "region4" {
  description             = "Multi-Region replica key"
  deletion_window_in_days = 30
  primary_key_arn         = var.primary_kms_key_arn
  provider                = aws.region4
}
