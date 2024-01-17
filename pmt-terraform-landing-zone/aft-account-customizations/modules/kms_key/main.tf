# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_kms_key" "this" {
  enable_key_rotation = true
  multi_region        = var.enable_multi_region
  policy              = var.key_policy
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.key_name}"
  target_key_id = aws_kms_key.this.key_id
}
