terraform {
  #   backend "s3" {
  #     bucket         = "useast1d-tf-state"
  #     key            = "wordpress-dev"
  #     region         = "us-east-1"
  #     encrypt        = "true"
  #     dynamodb_table = "useast1d-terraform-locks"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace    = local.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "auto_cw_alarm" {
  source = "../../modules/auto_cw_alarm"

  namespace               = local.namespace
  component               = local.component
  default_tags            = local.default_tags
  auto_scaling_group_name = module.asg.asg.name
}

module "cw_agent" {
  source = "../../modules/cw_agent"

  namespace     = local.namespace
  component     = local.component
  default_tags  = local.default_tags
  iam_role_name = module.ec2_role.role.name
  linux_config  = file("${path.module}/config_linux.json")
}

module "patching" {
  source = "../../modules/patching"

  namespace    = local.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "efs" {
  source = "../../modules/efs"

  namespace        = local.namespace
  component        = local.component
  default_tags     = local.default_tags
  is_encrypted     = true
  performance_mode = "generalPurpose"
  subnets          = data.aws_subnet_ids.private.ids
  security_groups  = [aws_security_group.efs.id]
}

module "alb" {
  source = "../../modules/alb"

  namespace       = local.namespace
  component       = local.component
  default_tags    = local.default_tags
  is_internal     = false
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnet_ids.public.ids
}

module "asg" {
  source = "../../modules/asg"

  namespace              = local.namespace
  component              = local.component
  subnets                = data.aws_subnet_ids.private.ids
  image_id               = data.aws_ami.this.image_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.asg.id]

  min_size                 = local.min_size
  max_size                 = local.max_size
  desired_capacity         = local.desired_capacity
  healthcheck_grace_period = 600
  healthcheck_type         = "ELB"
  force_delete             = true
  target_group_arns        = [module.target_group.target_group.arn]
  iam_instance_profile     = module.ec2_role.profile
  user_data                = filebase64("${path.module}/userdata.sh")

  default_tags = merge(
    local.default_tags,
    map("enable_patching", "true")
  )

  block_device_mappings = [
    {
      device_name : "/dev/xvda"
      volume_type : "gp2"
      volume_size : "30"
      delete_on_termination : true
      encrypted : true
    },
    {
      device_name : "/dev/xvdf"
      volume_type : "gp2"
      volume_size : "100"
      delete_on_termination : true
      encrypted : true
    }
  ]
}

module "target_group" {
  source = "../../modules/target_group"

  namespace             = local.namespace
  component             = local.component
  default_tags          = local.default_tags
  target_ids            = []
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id                = data.aws_vpc.this.id
  deregistration_delay  = 60
  enable_stickiness     = true
  elb_arn               = module.alb.alb.arn
  elb_type              = "ALB"
  elb_listener_port     = 80
  elb_listener_protocol = "HTTP"
}

module "rds" {
  source = "../../modules/rds"

  namespace          = local.namespace
  component          = local.component
  default_tags       = local.default_tags
  subnets            = data.aws_subnet_ids.private.ids
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  security_groups    = [aws_security_group.rds.id]
}
