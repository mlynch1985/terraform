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
  enable_flow_logs         = true
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
  security_groups   = [module.vpc.default_security_group.id, aws_security_group.alb.id]
  subnets           = module.vpc.public_subnets.*.id
  enable_stickiness = true
}

module "asg" {
  source = "./modules/asg"

  namespace                  = var.namespace
  default_tags               = local.default_tags
  name                       = "wordpress"
  image_id                   = data.aws_ami.amazon_linux_2.image_id
  instance_type              = "t3.large"
  security_groups            = [module.vpc.default_security_group.id]
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = true
  iam_instance_profile       = module.ec2_role.profile.arn
  asg_min                    = 3
  asg_max                    = 3
  asg_desired                = 3
  asg_subnets                = module.vpc.private_subnets.*.id
  target_group_arns          = [module.alb.target_group.arn]
  asg_healthcheck_type       = "ELB"
}

module "ec2_role" {
  source = "./modules/ec2_role"

  namespace    = var.namespace
  default_tags = local.default_tags
  name         = "wordpress"
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.namespace}_alb"
  vpc_id      = module.vpc.vpc.id

  ingress {
    protocol    = "tcp"
    self        = true
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.default_tags,
    map(
      "Name", "${var.namespace}_alb"
    )
  )
}
