terraform {
  backend "s3" {
    bucket  = "mltemp-sandbox-tfstate"
    region  = "us-east-1"
    encrypt = true
    key     = "useast1t_wordpress"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "random" {
  region = var.region
}


module "ec2_role" {
  source = "../modules/ec2_role"

  namespace    = var.namespace
  app_role     = var.app_role
  default_tags = local.default_tags
}

module "cwa" {
  source = "../modules/cwa"

  namespace    = var.namespace
  app_role     = var.app_role
  platform     = "linux"
  config_json  = file("${path.module}/cwa_config.json")
  default_tags = local.default_tags
}

module "patching" {
  source = "../modules/patching"

  namespace    = var.namespace
  app_role     = var.app_role
  default_tags = local.default_tags
}

module "efs" {
  source = "../modules/efs"

  namespace        = var.namespace
  app_role         = var.app_role
  default_tags     = local.default_tags
  is_encrypted     = true
  performance_mode = "generalPurpose"
  subnets          = data.aws_subnet_ids.private.ids
  security_groups  = [aws_security_group.efs.id]
}

module "alb" {
  source = "../modules/alb"

  namespace            = var.namespace
  app_role             = var.app_role
  default_tags         = local.default_tags
  is_internal          = false
  security_groups      = [aws_security_group.alb.id]
  subnets              = data.aws_subnet_ids.public.ids
  vpc_id               = data.aws_vpc.this.id
  deregistration_delay = 60
  enable_stickiness    = true
}

module "asg" {
  source = "../modules/asg"

  namespace                  = var.namespace
  app_role                   = var.app_role
  image_id                   = data.aws_ami.amazon_linux_2.image_id
  instance_type              = "t3.large"
  security_groups            = [aws_security_group.asg.id]
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = true
  iam_instance_profile       = module.ec2_role.profile.arn
  asg_min                    = 3
  asg_max                    = 3
  asg_desired                = 3
  asg_healthcheck_type       = "ELB"
  asg_subnets                = data.aws_subnet_ids.private.ids
  target_group_arns          = [module.alb.target_group.arn]

  default_tags = merge(
    local.default_tags,
    map(
      "ad_join", "true",
      "enable_patching", "true"
    )
  )
}

module "rds" {
  source = "../modules/rds"

  namespace          = var.namespace
  app_role           = var.app_role
  default_tags       = local.default_tags
  subnets            = data.aws_subnet_ids.private.ids
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  security_groups    = [aws_security_group.rds.id]
}
