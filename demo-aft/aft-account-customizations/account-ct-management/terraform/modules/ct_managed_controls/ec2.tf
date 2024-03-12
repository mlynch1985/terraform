# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  ec2 = {
    # [AWS-GR_EC2_INSTANCE_NO_PUBLIC_IP] Detect whether any Amazon EC2 instance has an associated public IPv4 address
    "AWS-GR_EC2_INSTANCE_NO_PUBLIC_IP" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.4] Stopped EC2 instances should be removed after a specified time period
    "GTXSQEJWOBFI" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.8] EC2 instances should use Instance Metadata Service Version 2 (IMDSv2)
    "RZXGVSCOVETI" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.9] EC2 instances should not have a public IPv4 address
    "MINKVOGPJARR" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "ec2" {
  for_each = merge([for control, ou_map in local.ec2 :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
