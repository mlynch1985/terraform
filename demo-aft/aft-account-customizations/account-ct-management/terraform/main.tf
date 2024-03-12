# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))

  audit_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.audit_account_name
  ][0]

  network_account_id = [
    for account in data.aws_organizations_organization.current.accounts : account.id
    if account.name == local.global_vars.network_account_name
  ][0]
}

data "aws_organizations_organization" "current" {}

module "ct_managed_controls" {
  source = "./modules/ct_managed_controls"

  providers = {
    # Related: https://github.com/hashicorp/terraform-provider-aws/issues/34669
    aws = aws.ct-management-increased-capacity
  }
}

module "protect_root_account_cloudwatch_alarms" {
  source = "./modules/protect_root_account_cloudwatch_alarms"
}

module "delegate_security_hub" {
  source            = "./modules/delegate_security_hub"
  target_account_id = local.audit_account_id

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "delegate_guardduty" {
  source            = "./modules/delegate_guardduty"
  target_account_id = local.audit_account_id

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "delegate_macie" {
  source            = "./modules/delegate_macie"
  target_account_id = local.audit_account_id

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "delegate_inspector" {
  source            = "./modules/delegate_inspector"
  target_account_id = local.audit_account_id

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "delegate_detective" {
  source            = "./modules/delegate_detective"
  target_account_id = local.audit_account_id

  providers = {
    aws.region1 = aws.region1,
    aws.region2 = aws.region2,
    aws.region3 = aws.region3,
    aws.region4 = aws.region4
  }
}

module "delegate_firewall_mgr" {
  source            = "./modules/delegate_firewall_mgr"
  target_account_id = local.audit_account_id

  providers = {
    aws = aws.use1 # FW Mgr is only supported in the Virginia region
  }
}

module "delegate_ipam" {
  source            = "./modules/delegate_ipam"
  target_account_id = local.network_account_id

  providers = {
    aws = aws.region1
  }
}
