# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  kms = {
    # [SH.KMS.1] IAM customer managed policies should not allow decryption actions on all KMS keys
    "ZYVSVOFNLTNG" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.KMS.2] IAM principals should not have IAM inline policies that allow decryption actions on all KMS keys
    "QNVYEARPCKHY" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.KMS.3] AWS KMS keys should not be deleted unintentionally
    "CKCEVZPVWRJV" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "kms" {
  for_each = merge([for control, ou_map in local.kms :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
