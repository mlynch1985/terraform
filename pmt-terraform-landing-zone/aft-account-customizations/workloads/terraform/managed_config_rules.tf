# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "managed_config_rules" {
  source = "../../modules/managed_config_rules"

  providers = {
    aws.region1 = aws.region1
    aws.region2 = aws.region2
  }

  rules = {
    "ACCESS_KEYS_ROTATED" : {
      source_identifier = "ACCESS_KEYS_ROTATED"
      input_parameters  = jsonencode({ maxAccessKeyAge = "90" })
      description       = "Checks if the active access keys are rotated within the number of days specified in maxAccessKeyAge. The rule is NON_COMPLIANT if the access keys have not been rotated for more than maxAccessKeyAge number of days."
    },
    "EBS_OPTIMIZED_INSTANCE" : {
      source_identifier = "EBS_OPTIMIZED_INSTANCE"
    }
  }
}
