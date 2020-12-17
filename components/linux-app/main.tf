terraform {
  backend "s3" {
    bucket         = "useast1d-tf-state"
    key            = "linux-app-dev"
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
  max_session_duration = 3600 # 1
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

## Deploys a single EC2 instance in the Private-1a subnet
module "ec2_instance" {
  source = "../../modules/ec2_instance"

  namespace            = local.namespace
  component            = local.component
  image_id             = data.aws_ami.this.image_id
  instance_type        = local.instance_type
  security_groups      = [aws_security_group.ec2.id]
  subnet_id            = tolist(data.aws_subnet_ids.private.ids)[0]
  user_data            = filebase64("${path.module}/userdata.sh")
  iam_instance_profile = module.ec2_role.profile.name

  default_tags = merge(
    local.default_tags,
    map("enable_patching", "true")
  )

  root_block_device = [
    {
      volume_type : "gp2"
      volume_size : "30"
      iops : null
      delete_on_termination : true
      encrypted : true
    }
  ]

  ebs_block_device = [
    {
      device_name : "/dev/sdf"
      volume_type : "gp3"
      volume_size : "100"
      iops : null
      delete_on_termination : true
      encrypted : true
    }
  ]
}

## Created Security Group allowing ALL traffic from the Private subnets only
resource "aws_security_group" "ec2" {
  name_prefix = "${local.namespace}_${local.component}_ec2_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = [for s in data.aws_subnet.private : s.cidr_block]
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
