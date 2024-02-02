# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  parent_domain_name  = "shared.dev.demo.cloud"
  account_domain_name = replace(lower("${data.aws_organizations_resource_tags.current.tags.Name}.dev.demo.cloud"), " ", "-")
}

data "aws_route53_zone" "parent_domain" {
  name         = local.parent_domain_name
  private_zone = true
  provider     = aws.network-region1
}

resource "aws_route53_zone" "account_domain" {
  name          = local.account_domain_name
  force_destroy = true # Used for testing, set to false for production environments

  vpc {
    vpc_id = module.vpc_region1.vpc_id
  }

  lifecycle {
    ignore_changes = [vpc]
  }
}

resource "aws_route53_zone_association" "local_region2" {
  zone_id  = aws_route53_zone.account_domain.zone_id
  vpc_id   = module.vpc_region2.vpc_id
  provider = aws.region2
}

resource "aws_route53_zone_association" "local_region3" {
  zone_id  = aws_route53_zone.account_domain.zone_id
  vpc_id   = module.vpc_region3.vpc_id
  provider = aws.region3
}

# Create A test record
resource "aws_route53_record" "test_record" {
  zone_id = aws_route53_zone.account_domain.zone_id
  name    = "test.${aws_route53_zone.account_domain.name}"
  type    = "A"
  ttl     = "300"
  records = ["1.1.1.1"]
}

module "route53_aws_region1" {
  source = "../../modules/route53_aws"

  account_zone_id    = aws_route53_zone.account_domain.zone_id
  account_vpc_id     = module.vpc_region1.vpc_id
  domain             = "dev"
  parent_domain_name = local.parent_domain_name
  parent_vpc_name    = "dev_shared_services"

  providers = {
    aws         = aws.region1
    aws.network = aws.network-region1
  }
}

module "route53_aws_region2" {
  source = "../../modules/route53_aws"

  account_zone_id    = aws_route53_zone.account_domain.zone_id
  account_vpc_id     = module.vpc_region2.vpc_id
  domain             = "dev"
  parent_domain_name = local.parent_domain_name
  parent_vpc_name    = "dev_shared_services"

  providers = {
    aws         = aws.region2
    aws.network = aws.network-region2
  }
}

module "route53_aws_region3" {
  source = "../../modules/route53_aws"

  account_zone_id    = aws_route53_zone.account_domain.zone_id
  account_vpc_id     = module.vpc_region3.vpc_id
  domain             = "dev"
  parent_domain_name = local.parent_domain_name
  parent_vpc_name    = "dev_shared_services"

  providers = {
    aws         = aws.region3
    aws.network = aws.network-region3
  }
}
