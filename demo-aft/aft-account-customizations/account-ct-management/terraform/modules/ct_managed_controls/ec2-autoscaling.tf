# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  ec2_autoscaling = {
    # [AWS-GR_AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED] Detect whether public IP addresses for Amazon EC2 Auto Scaling are enabled through launch configurations
    "AWS-GR_AUTOSCALING_LAUNCH_CONFIG_PUBLIC_IP_DISABLED" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.AutoScaling.1] Auto scaling groups associated with a load balancer should use load balancer health checks
    "ZWORVQKMSSVN" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.AutoScaling.2] Amazon EC2 Auto Scaling group should cover multiple Availability Zones
    "WPQFDZGIKXEN" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.AutoScaling.3] Auto Scaling group launch configurations should configure EC2 instances to require Instance Metadata Service Version 2 (IMDSv2)
    "HHCYIDJRAZNC" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # # Has been deprecated
    # # [SH.AutoScaling.4] Auto Scaling group launch configuration should not have a metadata response hop limit greater than 1
    # "IKDSUOXJFKTR" = {
    #   "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
    #   "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
    #   "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    # }

    # [SH.Autoscaling.5] Amazon EC2 instances launched using Auto Scaling group launch configurations should not have Public IP addresses
    "QVGJOLZXDNNY" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }

    # [SH.AutoScaling.9] EC2 Auto Scaling groups should use EC2 launch templates
    "VEIRXQKRRWAP" = {
      "${local.all_ous["Infrastructure"].id}" = local.all_ous["Infrastructure"].arn,
      "${local.all_ous["Sandbox"].id}"        = local.all_ous["Sandbox"].arn,
      "${local.all_ous["Workloads"].id}"      = local.all_ous["Workloads"].arn
    }
  }
}

resource "aws_controltower_control" "ec2_autoscaling" {
  for_each = merge([for control, ou_map in local.ec2_autoscaling :
    { for ou_id, ou_arn in ou_map : "${control}/${ou_id}" => { "control" = control, "ou_arn" = ou_arn } }
  ]...)

  control_identifier = "arn:aws:controltower:${data.aws_region.current.name}::control/${each.value.control}"
  target_identifier  = each.value.ou_arn
}
