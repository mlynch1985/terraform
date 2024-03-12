# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))
}

module "enable_security_hub_subscriptions" {
  source = "./modules/enable_security_hub_subscriptions"
  region = each.value

  for_each = toset([
    global_vars.region1,
    global_vars.region2,
    global_vars.region3,
    global_vars.region4
  ])
}
