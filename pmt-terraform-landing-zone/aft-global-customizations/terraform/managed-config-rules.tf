# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "managed_config_rules" {
  source = "./modules/managed_config_rules"

  providers = {
    aws.region1 = aws.region1
    aws.region2 = aws.region2
  }

  rules = {
    "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS" : {
      source_identifier = "S3_ACCOUNT_LEVEL_PUBLIC_ACCESS_BLOCKS"
      description       = "Checks if the required public access block settings are configured from account level. The rule is only NON_COMPLIANT when the fields set below do not match the corresponding fields in the configuration item."
      input_parameters = jsonencode({
        IgnorePublicAcls      = "True"
        BlockPublicPolicy     = "True"
        BlockPublicAcls       = "True"
        RestrictPublicBuckets = "True"
      })
    },
    "NO_UNRESTRICTED_ROUTE_TO_IGW" : {
      source_identifier = "NO_UNRESTRICTED_ROUTE_TO_IGW"
      description       = "A Config rule that checks if there are public routes in the route table to an Internet Gateway (IGW). The rule is NON_COMPLIANT if a route to an IGW has a destination CIDR block of '0.0.0.0/0' or '::/0' or if a destination CIDR block does not match the..."
    }
  }
}
