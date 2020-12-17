terraform {
  backend "s3" {
    bucket         = "useast1d-tf-state"
    key            = "linux-web-dev"
    region         = "us-east-1"
    encrypt        = "true"
    dynamodb_table = "useast1d-terraform-locks"
  }

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

## IAM Role that grants SSMManagedInstanceCore, ParameterStore, SecretsManager and S3 specific to this component
module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace            = local.namespace
  component            = local.component
  default_tags         = local.default_tags
  path                 = "/"
  description          = "Grants SSMManagedInstanceCore, ParameterStore, SecretsManager and S3 specific to this component"
  max_session_duration = 3600 # 1 hour
}

## Adds permission to IAM Role to publish custom metrics and logs to Cloudwatch.  Also publishes CW Agent config to ParameterStore
module "cw_agent" {
  source = "../../modules/cw_agent"

  namespace     = local.namespace
  component     = local.component
  default_tags  = local.default_tags
  iam_role_name = module.ec2_role.role.name
  linux_config  = file("${path.module}/config_linux.json")
}

## Configures a maintenance window to perform patching every night at midnight
module "patching" {
  source = "../../modules/patching"

  namespace         = local.namespace
  component         = local.component
  default_tags      = local.default_tags
  schedule_name     = "daily_patching"
  schedule_cron     = "cron(0 0 ? * * *)"
  schedule_timezone = "America/New_York"
  schedule_cutoff   = 1
  schedule_duration = 4
  target_tag_name   = "tag:enable_patching"
  target_tag_value  = "true"
  max_concurrency   = 5
  max_errors        = 2
}

## Creates a public facing Application Load Balancer
module "alb" {
  source = "../../modules/alb"

  namespace       = local.namespace
  component       = local.component
  default_tags    = local.default_tags
  is_internal     = false
  security_groups = [aws_security_group.alb.id]
  subnets         = data.aws_subnet_ids.public.ids
}

## Creates an AutoScalingGroup in the Private Subnet
module "asg" {
  source = "../../modules/asg"

  namespace              = local.namespace
  component              = local.component
  subnets                = data.aws_subnet_ids.private.ids
  image_id               = data.aws_ami.this.image_id
  instance_type          = local.instance_type
  vpc_security_group_ids = [aws_security_group.asg.id]

  min_size             = local.min_size
  max_size             = local.max_size
  desired_capacity     = local.desired_capacity
  healthcheck_type     = "ELB"
  force_delete         = true
  target_group_arns    = [module.target_group.target_group.arn]
  iam_instance_profile = module.ec2_role.profile
  user_data            = filebase64("${path.module}/userdata.sh")

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

## Created a Target Group listening on HTTP port 80
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
  healthcheck_path      = "/"
  elb_arn               = module.alb.alb.arn
  elb_type              = "ALB"
  elb_listener_port     = 80
  elb_listener_protocol = "HTTP"
  elb_listener_cert     = ""
}

## Created a Security Group that allows HTTP 80 from the world
resource "aws_security_group" "alb" {
  name_prefix = "${local.namespace}_${local.component}_alb_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
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
      "Name", "${local.namespace}/${local.component}/alb"
    )
  )
}

## Created Security Group that allows HTTP 80 from the ALB only
resource "aws_security_group" "asg" {
  name_prefix = "${local.namespace}_${local.component}_asg_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
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
      "Name", "${local.namespace}/${local.component}/asg"
    )
  )
}
