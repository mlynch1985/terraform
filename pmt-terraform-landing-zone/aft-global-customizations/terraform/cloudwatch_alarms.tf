# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "cloudwatch_alarms_region1" {
  source        = "./modules/cloudwatch_alarms"
  count         = local.ct_management_account_id == data.aws_caller_identity.current.account_id ? 1 : 0 # CT-Management Only
  alarm_actions = [module.securitynotification_sns_region1.topic_arn]

  providers = {
    aws = aws.region1
  }
}
