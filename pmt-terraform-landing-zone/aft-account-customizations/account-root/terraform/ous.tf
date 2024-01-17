# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "this" {
}

data "aws_organizations_organizational_units" "root" {
  parent_id = data.aws_organizations_organization.this.roots[0].id
}

data "aws_organizations_organizational_units" "exceptions" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Exceptions"][0]
}

data "aws_organizations_organizational_units" "sandbox" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Sandbox"][0]
}

data "aws_organizations_organizational_units" "security" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Security"][0]
}

data "aws_organizations_organizational_units" "deployments" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Deployments"][0]
}

data "aws_organizations_organizational_units" "workloads" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Workloads"][0]
}

data "aws_organizations_organizational_units" "policy-staging" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Policy Staging"][0]
}

data "aws_organizations_organizational_units" "suspended" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Suspended"][0]
}

data "aws_organizations_organizational_units" "infrastructure" {
  parent_id = [for ou in data.aws_organizations_organizational_units.root.children : ou.id if ou.name == "Infrastructure"][0]
}
