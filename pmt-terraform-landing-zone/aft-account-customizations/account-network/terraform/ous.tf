# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_organizations_organization" "this" {
  provider = aws.ct-management
}

data "aws_organizations_organizational_units" "root" {
  provider  = aws.ct-management
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

data "aws_organizations_organizational_units" "exceptions" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Exceptions"][0]
}

data "aws_organizations_organizational_units" "sandbox" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Sandbox"][0]
}

data "aws_organizations_organizational_units" "security" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Security"][0]
}

data "aws_organizations_organizational_units" "deployments" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Deployments"][0]
}

data "aws_organizations_organizational_units" "workloads" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Workloads"][0]
}

data "aws_organizations_organizational_units" "policy-staging" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Policy Staging"][0]
}

data "aws_organizations_organizational_units" "suspended" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Suspended"][0]
}

data "aws_organizations_organizational_units" "infrastructure" {
  provider  = aws.ct-management
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Infrastructure"][0]
}
