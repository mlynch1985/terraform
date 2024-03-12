# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "security_hub_subscriptions_region1" {
  source                    = "../../modules/security_hub_subscriptions"
  enable_aws_best_practices = true
  enable_cis_1_2_0          = true
  enable_cis_1_4_0          = false
  enable_pci_3_2_1          = true
  enable_nist_800_53_5      = true
  providers = {
    aws               = aws.region1
    aws.ct-management = aws.ct-management
  }

  depends_on = [aws_securityhub_organization_configuration.region1]
}

module "security_hub_subscriptions_region2" {
  source                    = "../../modules/security_hub_subscriptions"
  enable_aws_best_practices = true
  enable_cis_1_2_0          = true
  enable_cis_1_4_0          = false
  enable_pci_3_2_1          = true
  enable_nist_800_53_5      = true
  providers = {
    aws               = aws.region2
    aws.ct-management = aws.ct-management
  }

  depends_on = [aws_securityhub_organization_configuration.region2]
}

module "security_hub_subscriptions_region3" {
  source                    = "../../modules/security_hub_subscriptions"
  enable_aws_best_practices = true
  enable_cis_1_2_0          = true
  enable_cis_1_4_0          = false
  enable_pci_3_2_1          = true
  enable_nist_800_53_5      = true
  providers = {
    aws               = aws.region3
    aws.ct-management = aws.ct-management
  }

  depends_on = [aws_securityhub_organization_configuration.region3]
}

# module "security_hub_subscriptions_region4" {
#   source                    = "../../modules/security_hub_subscriptions"
#   enable_aws_best_practices = true
#   enable_cis_1_2_0          = true
#   enable_cis_1_4_0          = false
#   enable_pci_3_2_1          = true
#   enable_nist_800_53_5      = true
#   providers = {
#     aws               = aws.region4
#     aws.ct-management = aws.ct-management
#   }
#
#   depends_on = [aws_securityhub_organization_configuration.region4]
# }
