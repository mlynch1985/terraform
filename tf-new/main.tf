terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  namespace                = var.namespace
  default_tags             = local.default_tags
  cidr_block               = "10.0.0.0/16"
  deploy_public_subnets    = true
  deploy_private_subnets   = true
  deploy_protected_subnets = true
}

module "alb" {
  source = "./modules/alb"

  namespace         = var.namespace
  default_tags      = local.default_tags
  name              = "wordpress"
  is_internal       = false
  vpc_id            = module.vpc.vpc.id
  security_groups   = [module.vpc.default_security_group.id]
  subnets           = module.vpc.public_subnets.*.id
  enable_stickiness = true
}

module "asg" {
  source = "./modules/asg"

  namespace                  = var.namespace
  default_tags               = local.default_tags
  name                       = "wordpress"
  image_id                   = data.aws_ami.amazon_linux_2.image_id
  instance_type              = "c5.large"
  security_groups            = [module.vpc.default_security_group.id]
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = true
  iam_instance_profile       = ""
  asg_subnets                = module.vpc.private_subnets.*.id
  target_group_arns          = [module.alb.target_group.arn]
  asg_healthcheck_type       = "EC2"
}
