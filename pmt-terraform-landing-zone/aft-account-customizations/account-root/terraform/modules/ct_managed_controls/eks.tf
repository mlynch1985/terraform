# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  eks = {
    # [AWS-GR_EKS_ENDPOINT_NO_PUBLIC_ACCESS] Detect whether an Amazon EKS endpoint is blocked from public access
    "AWS-GR_EKS_ENDPOINT_NO_PUBLIC_ACCESS" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EKS.2] EKS clusters should run on a supported Kubernetes version
    "RDAUUJAGICFK" = {
      "${local.all_ous["Deployments"].id}"    = local.all_ous["Deployments"].arn,
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "eks" {
  for_each = merge([for control, ou_map in local.eks :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
