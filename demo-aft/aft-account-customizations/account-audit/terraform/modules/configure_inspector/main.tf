# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}

resource "aws_inspector2_organization_configuration" "this" {
  auto_enable {
    ec2         = true
    ecr         = true
    lambda      = true
    lambda_code = false
  }
}

resource "aws_inspector2_enabler" "this" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR", "EC2", "LAMBDA"]
  depends_on     = [aws_inspector2_organization_configuration.this]
}
