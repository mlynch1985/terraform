# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  vpc = {
    # [AWS-GR_NO_UNRESTRICTED_ROUTE_TO_IGW] Detect whether public routes exist in the route table for an Internet Gateway (IGW)
    "AWS-GR_NO_UNRESTRICTED_ROUTE_TO_IGW" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [AWS-GR_RESTRICTED_COMMON_PORTS] Detect whether unrestricted incoming TCP traffic is allowed
    "AWS-GR_RESTRICTED_COMMON_PORTS" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [AWS-GR_RESTRICTED_SSH] Detect whether unrestricted internet connection through SSH is allowed
    "AWS-GR_RESTRICTED_SSH" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED] Detect whether any Amazon VPC subnets are assigned a public IP address
    "AWS-GR_SUBNET_AUTO_ASSIGN_PUBLIC_IP_DISABLED" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.2] The VPC default security group should not allow inbound and outbound traffic
    "CBXAVYGTSXPR" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.6] VPC flow logging should be enabled in all VPCs
    "BEEYZGSRRAZM" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.10] Amazon EC2 should be configured to use VPC endpoints that are created for the Amazon EC2 service
    "VAUYZRKDCKOY" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.15] EC2 subnets should not automatically assign public IP addresses
    "RJQGGVJZEBLT" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.16] Unused Network Access Control Lists should be removed
    "LITUIAJFCNLG" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.18] Security groups should only allow unrestricted incoming traffic for authorized ports
    "BKEEVLXJOIZI" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.19] Security groups should not allow unrestricted access to ports with high risk
    "KTVMUAUBZNOK" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.21] Network ACLs should not allow ingress from 0.0.0.0/0 to port 22 or port 3389
    "AVYCVZQFCQNU" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.22] Unused EC2 security groups should be removed
    "DKOGNVMOVXDM" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.EC2.25] EC2 launch templates should not assign public IPs to network interfaces
    "YCRFUQNWQGOU" = {
      # "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn, # Network accounts are exempt
      "${local.all_ous["Sandbox"].id}"   = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}" = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "vpc" {
  for_each = merge([for control, ou_map in local.vpc :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
