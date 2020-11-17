terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {}
provider "random" {}

module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace    = var.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "auto_cw_alarm" {
  source = "../../modules/auto_cw_alarm"

  namespace               = var.namespace
  component               = local.component
  default_tags            = local.default_tags
  auto_scaling_group_name = module.asg.asg.name
}

module "cw_agent" {
  source = "../../modules/cw_agent"

  namespace    = var.namespace
  component    = local.component
  default_tags = local.default_tags
  linux_config = file("${path.module}/config_linux.json")
}

module "patching" {
  source = "../../modules/patching"

  namespace    = var.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "efs" {
  source = "../../modules/efs"

  namespace        = var.namespace
  component        = local.component
  default_tags     = local.default_tags
  is_encrypted     = true
  performance_mode = "generalPurpose"
  subnets          = data.aws_subnet_ids.private.ids
  security_groups  = [aws_security_group.efs.id]
}

module "alb" {
  source = "../../modules/alb"

  namespace            = var.namespace
  component            = local.component
  default_tags         = local.default_tags
  is_internal          = false
  security_groups      = [aws_security_group.alb.id]
  subnets              = data.aws_subnet_ids.public.ids
  vpc_id               = data.aws_vpc.this.id
  deregistration_delay = 60
  enable_stickiness    = true
}

module "asg" {
  source = "../../modules/asg"

  namespace                  = var.namespace
  component                  = local.component
  image_id                   = data.aws_ami.amazon_linux_2.image_id
  instance_type              = local.instance_type
  security_groups            = [aws_security_group.asg.id]
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = true
  iam_instance_profile       = module.ec2_role.profile.arn
  asg_min                    = local.asg_min
  asg_max                    = local.asg_max
  asg_desired                = local.asg_desired
  asg_healthcheck_type       = "ELB"
  asg_subnets                = data.aws_subnet_ids.private.ids
  target_group_arns          = [module.alb.target_group.arn]

  default_tags = merge(
    local.default_tags,
    map(
      "enable_patching", "true"
    )
  )
}

module "rds" {
  source = "../../modules/rds"

  namespace          = var.namespace
  component          = local.component
  default_tags       = local.default_tags
  subnets            = data.aws_subnet_ids.private.ids
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  security_groups    = [aws_security_group.rds.id]
}
