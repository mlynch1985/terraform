# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  iam = {
    # [AWS-GR_RESTRICT_ROOT_USER_ACCESS_KEYS] Disallow creation of access keys for the root user
    "AWS-GR_RESTRICT_ROOT_USER_ACCESS_KEYS" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [AWS-GR_RESTRICT_ROOT_USER] Disallow actions as a root user
    "AWS-GR_RESTRICT_ROOT_USER" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [AWS-GR_ROOT_ACCOUNT_MFA_ENABLED] Detect whether MFA for the root user is enabled
    "AWS-GR_ROOT_ACCOUNT_MFA_ENABLED" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.1] IAM policies should not allow full "*" administrative privileges
    "GQRKBUMEATXJ" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.2] IAM users should not have IAM policies attached
    "CKRCAIBXILFK" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.3] IAM users' access keys should be rotated every 90 days or less
    "ZEJBJAESPURY" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.4] IAM root user access key should not exist
    "MLZMKASTNAMJ" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.5] MFA should be enabled for all IAM users that have a console password
    "JZAYNLETVJSZ" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.6] Hardware MFA should be enabled for the root user
    "YXQAYRGZITSE" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.7] Password policies for IAM users should have strong configurations
    "YJDQWPMKBQWV" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.8] Unused IAM user credentials should be removed
    "DYZBFPIWFDCI" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.IAM.21] IAM customer managed policies that you create should not allow wildcard actions for services
    "HQVLATIMVODA" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "iam" {
  for_each = merge([for control, ou_map in local.iam :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
