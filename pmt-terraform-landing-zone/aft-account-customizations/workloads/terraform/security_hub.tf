# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "security_hub_subscriptions_region1" {
  source                    = "../../modules/security_hub_subscriptions"
  enable_aws_best_practices = true
  enable_cis_1_2_0          = true
  enable_pci_3_2_1          = true
  providers = {
    aws = aws.region1
  }
}

module "security_hub_subscriptions_region2" {
  source                    = "../../modules/security_hub_subscriptions"
  enable_aws_best_practices = true
  enable_cis_1_2_0          = true
  enable_pci_3_2_1          = true
  providers = {
    aws = aws.region2
  }
}
