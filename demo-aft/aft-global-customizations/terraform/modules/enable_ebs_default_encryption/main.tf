# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_ebs_encryption_by_default" "region1" {
  enabled  = true
  provider = aws.region1
}

resource "aws_ebs_encryption_by_default" "region2" {
  enabled  = true
  provider = aws.region2
}

resource "aws_ebs_encryption_by_default" "region3" {
  enabled  = true
  provider = aws.region3
}

resource "aws_ebs_encryption_by_default" "region4" {
  enabled  = true
  provider = aws.region4
}
