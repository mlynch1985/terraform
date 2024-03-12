# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  global_vars = yamldecode(file(abspath("../../${path.module}/global_vars.yaml")))
}

module "configure_security_hub_region1" {
  source = "./modules/configure_security_hub"

  providers = {
    aws = aws.region1
  }
}

module "configure_security_hub_region2" {
  source     = "./modules/configure_security_hub"
  depends_on = [module.configure_security_hub_region1]

  providers = {
    aws = aws.region2
  }
}

module "configure_security_hub_region3" {
  source     = "./modules/configure_security_hub"
  depends_on = [module.configure_security_hub_region2]

  providers = {
    aws = aws.region3
  }
}

module "configure_security_hub_region4" {
  source     = "./modules/configure_security_hub"
  depends_on = [module.configure_security_hub_region3]

  providers = {
    aws = aws.region4
  }
}

resource "aws_securityhub_finding_aggregator" "audit" {
  linking_mode = "ALL_REGIONS"
  depends_on   = [module.configure_security_hub_region4]
}

module "configure_guardduty_region1" {
  source = "./modules/configure_guardduty"

  providers = {
    aws = aws.region1
  }
}

module "configure_guardduty_region2" {
  source     = "./modules/configure_guardduty"
  depends_on = [module.configure_guardduty_region1]

  providers = {
    aws = aws.region2
  }
}

module "configure_guardduty_region3" {
  source     = "./modules/configure_guardduty"
  depends_on = [module.configure_guardduty_region2]

  providers = {
    aws = aws.region3
  }
}

module "configure_guardduty_region4" {
  source     = "./modules/configure_guardduty"
  depends_on = [module.configure_guardduty_region3]

  providers = {
    aws = aws.region4
  }
}

module "configure_inspector_region1" {
  source = "./modules/configure_inspector"

  providers = {
    aws = aws.region1
  }
}

module "configure_inspector_region2" {
  source     = "./modules/configure_inspector"
  depends_on = [module.configure_inspector_region1]

  providers = {
    aws = aws.region2
  }
}

module "configure_inspector_region3" {
  source     = "./modules/configure_inspector"
  depends_on = [module.configure_inspector_region2]

  providers = {
    aws = aws.region3
  }
}

module "configure_inspector_region4" {
  source     = "./modules/configure_inspector"
  depends_on = [module.configure_inspector_region3]

  providers = {
    aws = aws.region4
  }
}

module "configure_detective_region1" {
  source = "./modules/configure_detective"

  providers = {
    aws = aws.region1
  }
}

module "configure_detective_region2" {
  source     = "./modules/configure_detective"
  depends_on = [module.configure_detective_region1]

  providers = {
    aws = aws.region2
  }
}

module "configure_detective_region3" {
  source     = "./modules/configure_detective"
  depends_on = [module.configure_detective_region2]

  providers = {
    aws = aws.region3
  }
}

module "configure_detective_region4" {
  source     = "./modules/configure_detective"
  depends_on = [module.configure_detective_region3]

  providers = {
    aws = aws.region4
  }
}
