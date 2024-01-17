# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_inspector2_enabler" "region1" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR", "EC2", "LAMBDA"]
  provider       = aws.region1
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_inspector2_enabler" "region2" {
  account_ids    = [data.aws_caller_identity.current.account_id]
  resource_types = ["ECR", "EC2", "LAMBDA"]
  provider       = aws.region2
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_inspector2_organization_configuration" "region1" {
  auto_enable {
    ec2    = true
    ecr    = true
    lambda = true
  }

  provider   = aws.region1
  depends_on = [aws_inspector2_enabler.region1]
}

resource "aws_inspector2_organization_configuration" "region2" {
  auto_enable {
    ec2    = true
    ecr    = true
    lambda = true
  }

  provider   = aws.region2
  depends_on = [aws_inspector2_enabler.region2]
}
