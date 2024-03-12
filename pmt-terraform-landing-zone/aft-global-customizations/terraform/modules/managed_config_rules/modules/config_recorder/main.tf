# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_config_configuration_recorder" "this" {
  name     = "aft_config_recorder"
  role_arn = aws_iam_role.this.arn

  recording_group {
    all_supported = true
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "aft_config_recorder"
  s3_bucket_name = aws_s3_bucket.this.bucket

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_configuration_recorder_status" "this" {
  name       = aws_config_configuration_recorder.this.name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.this]
}
