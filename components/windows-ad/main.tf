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

## IAM Role that grants SSMManagedInstanceCore, ParameterStore, SecretsManager and S3 specific to this component
module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace            = local.namespace
  component            = local.component
  default_tags         = local.default_tags
  path                 = "/"
  description          = "Grants SSMManagedInstanceCore, ParameterStore, SecretsManager and S3 specific to this component"
  max_session_duration = 3600 # 1
}

## Adds permission to IAM Role to publish custom metrics and logs to Cloudwatch.  Also publishes CW Agent config to ParameterStore
module "cw_agent" {
  source = "../../modules/cw_agent"

  namespace      = local.namespace
  component      = local.component
  default_tags   = local.default_tags
  iam_role_name  = module.ec2_role.role.name
  windows_config = file("${path.module}/config_windows.json")
}

## Creates a MS Active Directory using the AWS Directory Service and configures SSM Association to auto-join EC2 instances
module "msad" {
  source = "../../modules/msad"

  namespace           = local.namespace
  component           = local.component
  default_tags        = local.default_tags
  domain_name         = local.domain_name
  vpc_id              = data.aws_vpc.this.id
  subnet_1            = tolist(data.aws_subnet_ids.private.ids)[0]
  subnet_2            = tolist(data.aws_subnet_ids.private.ids)[1]
  edition             = "Standard"
  enable_sso          = true
  iam_ec2_role        = module.ec2_role.role.name
  enable_auto_join    = true
  ad_target_tag_name  = "tag:ad_join"
  ad_target_tag_value = "true"
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

## Deploys a single EC2 instance in the Private-1a subnet
module "ec2_instance" {
  source = "../../modules/ec2_instance"

  namespace                   = local.namespace
  component                   = local.component
  image_id                    = data.aws_ami.windows_2019.image_id
  security_groups             = [aws_security_group.ec2.id]
  subnet_id                   = tolist(data.aws_subnet_ids.private.ids)[0]
  instance_type               = local.instance_type
  key_name                    = ""
  enable_detailed_monitoring  = false
  associate_public_ip_address = false
  user_data                   = filebase64("${path.module}/userdata.ps1")
  iam_instance_profile        = module.ec2_role.profile.name
  enable_second_drive         = true

  default_tags = merge(
    local.default_tags,
    map(
      "enable_patching", "true",
      "ad_join", "true"
    )
  )

  root_block_device = {
    device_name : "/dev/sda1"
    volume_type : "gp2"
    volume_size : "30"
    delete_on_termination : true
    encrypted : true
  }

  ebs_block_device = {
    device_name : "xvdf"
    volume_type : "gp2"
    volume_size : "50"
    delete_on_termination : true
    encrypted : true
  }
}

## Creates public facing Network Load Balancer to allow RDP
module "nlb" {
  source = "../../modules/nlb"

  namespace                        = local.namespace
  component                        = local.component
  default_tags                     = local.default_tags
  subnets                          = data.aws_subnet_ids.public.ids
  is_internal                      = false
  enable_cross_zone_load_balancing = true
}

## Creates a Target Group listening on TCP 3389 for RDP access
module "target_group" {
  source = "../../modules/target_group"

  namespace             = local.namespace
  component             = local.component
  default_tags          = local.default_tags
  target_ids            = [module.ec2_instance.with_ebs_instance[0].id]
  target_group_port     = 3389
  target_group_protocol = "TCP"
  vpc_id                = data.aws_vpc.this.id
  deregistration_delay  = 60
  enable_stickiness     = true
  healthcheck_path      = ""
  elb_arn               = module.nlb.nlb.arn
  elb_type              = "NLB"
  elb_listener_port     = 3389
  elb_listener_protocol = "TCP"
  elb_listener_cert     = ""
}

## Created Security Group allowing ALL traffic from the Private subnets only and 3389 from the NLB/Public
resource "aws_security_group" "ec2" {
  name_prefix = "${local.namespace}_${local.component}_ec2_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 3389
    to_port     = 3389
    cidr_blocks = [for s in data.aws_subnet.public : s.cidr_block]
  }

  ingress {
    protocol    = "TCP"
    from_port   = 3389
    to_port     = 3389
    cidr_blocks = ["100.34.0.0/16"]
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
      "Name", "${local.namespace}/${local.component}/ec2"
    )
  )
}
