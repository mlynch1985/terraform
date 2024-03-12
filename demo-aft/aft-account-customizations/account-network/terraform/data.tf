# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))
}

data "aws_caller_identity" "current" {}

data "aws_availability_zones" "region1" {
  state    = "available"
  provider = aws.region1
}

data "aws_availability_zones" "region2" {
  state    = "available"
  provider = aws.region2
}

data "aws_availability_zones" "region3" {
  state    = "available"
  provider = aws.region3
}

data "aws_sns_topic" "aws_controltower_securitynotification_region1" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region1
}

data "aws_sns_topic" "aws_controltower_securitynotification_region2" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region2
}

data "aws_sns_topic" "aws_controltower_securitynotification_region3" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region3
}
