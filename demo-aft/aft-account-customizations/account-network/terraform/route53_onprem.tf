# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


module "dev_route53_onprem_resolvers_region1" {
  source = "./modules/route53_resolvers"

  allowed_ip_range = local.region1_pool
  domain           = "dev.demo.onprem"
  endpoints_vpc    = module.dev_vpc_shared_services_region1
  onprem_ips       = ["1.1.1.1", "8.8.8.8"]
  ram_principals   = [local.all_ous["Workloads/Dev"].arn]
  depends_on       = [aws_route53_zone.aws_private]

  providers = {
    aws = aws.region1
  }
}

module "dev_route53_onprem_resolvers_region2" {
  source = "./modules/route53_resolvers"

  allowed_ip_range = local.region2_pool
  domain           = "dev.demo.onprem"
  endpoints_vpc    = module.dev_vpc_shared_services_region2
  onprem_ips       = ["1.1.1.1", "8.8.8.8"]
  ram_principals   = [local.all_ous["Workloads/Dev"].arn]
  depends_on       = [aws_route53_zone.aws_private]

  providers = {
    aws = aws.region2
  }
}

module "dev_route53_onprem_resolvers_region3" {
  source = "./modules/route53_resolvers"

  allowed_ip_range = local.region3_pool
  domain           = "dev.demo.onprem"
  endpoints_vpc    = module.dev_vpc_shared_services_region3
  onprem_ips       = ["1.1.1.1", "8.8.8.8"]
  ram_principals   = [local.all_ous["Workloads/Dev"].arn]
  depends_on       = [aws_route53_zone.aws_private]

  providers = {
    aws = aws.region3
  }
}
