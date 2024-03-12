# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  codebuild = {
    # [SH.CodeBuild.2] CodeBuild project environment variables should not contain clear text credentials
    "SNJCJYKNUBTW" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.CodeBuild.3] CodeBuild S3 logs should be encrypted
    "PSTQZTBWYCPR" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.CodeBuild.4] CodeBuild project environments should have a logging configuration
    "HQVCCVHGQAZB" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.CodeBuild.5] CodeBuild project environments should not have privileged mode enabled
    "KMMZLEUZMTDU" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "codebuild" {
  for_each = merge([for control, ou_map in local.codebuild :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
