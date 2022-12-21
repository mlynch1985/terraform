module "vpc" {
  source = "../../modules/vpc"

  region      = var.region
  cidr_block  = var.cidr_block
  az_zone_ids = var.az_zone_ids
}

resource "aws_route53_zone" "primary" {
  name          = "arcusfi.com"
  force_destroy = true

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

module "nlb" {
  source = "../../modules/nlb"

  region          = "us-east-2"
  vpc_id          = "vpc-021e638216bc5f1bf"
  instance_ids    = ["i-0ecf102f6c80fa273"]
  assume_role_arn = "arn:aws:iam::982348816326:role/acrus-test"
  subnets         = ["subnet-013591a5b1ec783a7", "subnet-0599aa7984b379b8c"]
  certificate_arn = "arn:aws:acm:us-east-2:982348816326:certificate/5e2bf280-e759-4eea-ba8e-88d73af4523d"
}

module "pll-service" {
  source = "../../modules/pl-endpoint-service"

  region                     = "us-east-2"
  assume_role_arn            = "arn:aws:iam::982348816326:role/acrus-test"
  allowed_principals         = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
  network_load_balancer_arns = [module.nlb.nlb_arn]
}

resource "aws_vpc_endpoint" "bastion1" {
  vpc_id              = module.vpc.vpc_id
  service_name        = module.pll-service.service_name
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [module.vpc.default_security_group.id]
  private_dns_enabled = false
  subnet_ids          = module.vpc.private_subnets[*].id
}

resource "aws_route53_record" "bastion1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "bastion1.arcusfi.com"
  type    = "CNAME"
  ttl     = 5
  records = [aws_vpc_endpoint.bastion1.service_name]
}
