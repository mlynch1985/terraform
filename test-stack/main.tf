terraform {
  cloud {
    organization = "lynchbros"

    workspaces {
      name = "test-stack"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.15"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Creator      = var.creator
      Owner        = var.owner
      Organization = var.organization
      Environment  = var.environment
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_ami" "amazonlinux2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "asg" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/asg/"

  image_id               = data.aws_ami.amazonlinux2.id
  instance_type          = "c5.xlarge"
  server_name            = "app_server"
  vpc_security_group_ids = [module.vpc.default_security_group.id]
  kms_key_arn            = module.kms_key_asg.arn
  subnets                = module.vpc.private_subnets[*].id

  user_data                = null
  iam_instance_profile     = module.iam_role.profile
  min_size                 = 1
  max_size                 = 3
  healthcheck_grace_period = 300
  healthcheck_type         = "EC2"
  desired_capacity         = 3
  target_group_arns        = []

  block_device_mappings = [
    {
      device_name : "/dev/xvda"
      volume_type : "gp3"
      volume_size : "50"
      iops : null
      delete_on_termination : true
    },
    {
      device_name : "xvdf"
      volume_type : "gp3"
      volume_size : "100"
      iops : null
      delete_on_termination : true
    }
  ]
}

module "iam_role" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/iam_role/"

  service   = "ec2"
  role_name = "use1_dev_ec2_servers"
}

module "ipam" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/ipam/"

  region                            = var.region
  namespace                         = var.namespace
  environment                       = var.environment
  allocation_default_netmask_length = 20
  allocation_min_netmask_length     = 16
  allocation_max_netmask_length     = 28
  ipam_cidr                         = "10.0.0.0/8"
}

module "kms_key_asg" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/kms_key/"

  key_name            = "${var.namespace}/${var.environment}/asg"
  iam_roles           = [module.iam_role.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  enable_multi_region = false
}

module "kms_key_s3_bucket" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/kms_key/"

  key_name            = "${var.namespace}/${var.environment}/s3_bucket"
  iam_roles           = [module.iam_role.arn]
  enable_multi_region = false
}

module "s3_bucket" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/s3_bucket/"

  bucket_name = "${var.namespace}-${var.environment}-app1"
  key_arn     = module.kms_key_s3_bucket.arn
  iam_roles   = [module.iam_role.arn]
}

module "vpc" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/vpc/"

  namespace            = "use1"
  environment          = "dev"
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  subnet_size_offset   = 8
  target_az_count      = 3
  tgw_id               = ""
  vpc_type             = "hub"
}
