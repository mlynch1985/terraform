# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}

data "aws_sns_topic" "aws_controltower_securitynotification_region1" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region1
}

data "aws_sns_topic" "aws_controltower_securitynotification_region2" {
  name     = "aws-controltower-SecurityNotifications"
  provider = aws.region2
}

locals {
  # Set Region and AZ details needed for VPCs and IPAMs
  region1_name        = "us-east-1"
  region1_az_zone_ids = ["use1-az1", "use1-az2", "use1-az4"] # Currently az3 is not supported in Virginia
  region3_name        = "us-west-2"
  region2_az_zone_ids = ["usw2-az1", "usw2-az2", "usw2-az3"]

  # Get OU ARNs
  exceptions_arn     = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Exceptions"][0]
  sandbox_arn        = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Sandbox"][0]
  security_arn       = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Security"][0]
  deployments_arn    = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Deployments"][0]
  workloads_arn      = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Workloads"][0]
  policy_staging_arn = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Policy Staging"][0]
  suspended_arn      = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Suspended"][0]
  infrastructure_arn = [for ou in data.aws_organizations_organizational_units.root.children : ou.arn if ou.name == "Infrastructure"][0]

  # Import IPAM CIDRs from API Helper
  ipam_cidrs_region1 = { for vpc in jsondecode(file("ipam_cidrs_region1.json")) : vpc.VpcId => vpc }
  ipam_cidrs_region2 = { for vpc in jsondecode(file("ipam_cidrs_region2.json")) : vpc.VpcId => vpc }
}
