# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  # Set Region and AZ details needed for VPCs & IPAM
  region1_name        = "us-east-1"
  region1_az_zone_ids = ["use1-az1", "use1-az2", "use1-az4"] # Currently az3 is not supported in Virginia
  region2_name        = "us-west-2"
  region2_az_zone_ids = ["usw2-az1", "usw2-az2", "usw2-az3"]
}

data "aws_sns_topic" "aws_controltower_securitynotification_region1" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region1
}

data "aws_sns_topic" "aws_controltower_securitynotification_region2" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region2
}
