terraform {
  required_version = ">= 1.0"

  cloud {
    organization = "lynchbros"

    workspaces {
      name = "test-stack"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Creator      = var.creator
      Environment  = var.environment
      Namespace    = var.namespace
      Organization = var.organization
      Owner        = var.owner
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

# module "ipam" {
#   source = "../custom-modules-examples/ipam/"

#   # Required Parameters
#   ipam_cidr = "10.0.0.0/8"

#   # Optional Parameters
#   allocation_default_netmask_length = 20
#   allocation_max_netmask_length     = 28
#   allocation_min_netmask_length     = 16
# }

module "vpc" {
  source = "../custom-modules-examples/vpc/"

  # Required Parameters
  environment = var.environment
  namespace   = var.namespace

  # Optional Parameters
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  # ipam_pool_id         = module.ipam.pool_id
  # ipam_pool_netmask    = 20
  subnet_size_offset = 6
  target_az_count    = 3
  tgw_id             = ""
  vpc_type           = "hub"

  # Ensures the IPAM is fully established before trying to provision a CIDR for this VPC
  # depends_on = [
  #   module.ipam.cidr
  # ]
}

module "iam_role" {
  source = "../custom-modules-examples/iam_role/"

  # Required Parameters
  role_name = "${var.namespace}_${var.environment}_ec2_"
  service   = "ec2"

  # Optional Parameters
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  inline_policy_json = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-bucket/*"
    }
  ]
}
EOF
}

# Creating manually so KMS Key policy can reference the ARN during creation
resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}

module "kms_key_asg" {
  source = "../custom-modules-examples/kms_key/"

  # Required Parameters
  iam_roles = [module.iam_role.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  key_name  = "${var.namespace}/${var.environment}/asg"

  # Optional Parameters
  enable_key_rotation = true
  enable_multi_region = false

  # Service Linked Role must exist before we can attempt to add it to the key policy
  depends_on = [
    aws_iam_service_linked_role.autoscaling
  ]
}

module "alb_security_group" {
  source = "../custom-modules-examples/security_group/"

  group_name_prefix = "${var.namespace}-${var.environment}-alb"
  vpc_id            = module.vpc.vpc.id

  rules = [
    {
      cidr_blocks              = "100.34.0.0/16"
      description              = "allow inbound from my home"
      from_port                = "80"
      protocol                 = "tcp"
      source_security_group_id = null
      to_port                  = "80"
      type                     = "ingress"
    },
    {
      cidr_blocks              = "0.0.0.0/0"
      description              = "allow all outbound"
      from_port                = "0"
      protocol                 = "-1"
      source_security_group_id = null
      to_port                  = "0"
      type                     = "egress"
    }
  ]
}

module "asg_security_group" {
  source = "../custom-modules-examples/security_group/"

  group_name_prefix = "${var.namespace}-${var.environment}-asg"
  vpc_id            = module.vpc.vpc.id

  rules = [
    {
      cidr_blocks              = ""
      description              = "allow inbound from alb"
      from_port                = "80"
      protocol                 = "tcp"
      source_security_group_id = module.alb_security_group.id
      to_port                  = "80"
      type                     = "ingress"
    },
    {
      cidr_blocks              = "0.0.0.0/0"
      description              = "allow all outbound"
      from_port                = "0"
      protocol                 = "-1"
      source_security_group_id = null
      to_port                  = "0"
      type                     = "egress"
    }
  ]
}

module "efs_security_group" {
  source = "../custom-modules-examples/security_group/"

  group_name_prefix = "${var.namespace}-${var.environment}-efs"
  vpc_id            = module.vpc.vpc.id

  rules = [
    {
      cidr_blocks              = ""
      description              = "allow inbound from asg"
      from_port                = "2049"
      protocol                 = "tcp"
      source_security_group_id = module.asg_security_group.id
      to_port                  = "2049"
      type                     = "ingress"
    },
    {
      cidr_blocks              = "0.0.0.0/0"
      description              = "allow all outbound"
      from_port                = "0"
      protocol                 = "-1"
      source_security_group_id = null
      to_port                  = "0"
      type                     = "egress"
    }
  ]
}

module "efs" {
  source = "../custom-modules-examples/efs/"

  # Require Parameters
  enable_lifecycle_policy = true
  iam_role                = module.iam_role.arn
  performance_mode        = "generalPurpose"
  security_groups         = [module.efs_security_group.id]
  subnets                 = module.vpc.private_subnets[*].id
  throughput_mode         = "bursting"

  # Optional Parameters
  kms_key_arn            = ""
  provisioned_throughput = 0

  # Ensure the Security Group creation has completed prior to creating EFS share
  depends_on = [
    module.efs_security_group.id
  ]
}

module "asg" {
  source = "../custom-modules-examples/asg/"

  # Required Parameters
  image_id               = data.aws_ami.amazonlinux2.id
  instance_type          = "c5.xlarge"
  server_name            = "app_server"
  subnets                = module.vpc.private_subnets[*].id
  vpc_security_group_ids = [module.vpc.default_security_group.id, module.asg_security_group.id]

  # Optional Parameters
  healthcheck_grace_period = 300
  healthcheck_type         = "EC2"
  iam_instance_profile     = module.iam_role.profile
  max_size                 = 6
  min_size                 = 1

  block_device_mappings = [
    {
      device_name           = "/dev/xvda"
      delete_on_termination = true
      encrypted             = true
      iops                  = 0
      kms_key_id            = module.kms_key_asg.arn
      throughput            = 0
      volume_type           = "gp3"
      volume_size           = 50
    }
  ]

  target_groups = [
    {
      deregistration_delay  = 0    # 300 seconds
      enable_healthcheck    = true # true
      enable_stickiness     = true # false
      group_port            = 80
      group_protocol        = "HTTP"
      health_check_interval = 0 # 30
      health_check_matcher  = "200-299"
      health_check_path     = "/"
      health_check_port     = 0  # traffic_port
      health_check_protocol = "" # HTTP
      health_check_timeout  = 0  # 5 seconds
      healthy_threshold     = 0  # 3 count
      stickiness_type       = "" # lb_cookie
      target_type           = "" # instance
      unhealthy_threshold   = 0  # 3 count
      vpc_id                = module.vpc.vpc.id
    }
  ]

  # Inline User Data Script
  user_data = base64encode(<<-EOF
    #!/bin/bash
    amazon-linux-extras install -y epel
    yum install -q -y amazon-efs-utils
    mkdir -p /var/www/html
    echo "${module.efs.id}:/ /var/www/html efs _netdev,tls,iam 0 0" >> /etc/fstab
    mount -a
    yum install -y -q httpd
    echo "Hello World from $(hostname -f)" >> /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    yum upgrade -y -q
    EOF
  )

  # Ensure the EFS Share creation completed prior to creating the ASG
  depends_on = [
    module.efs.id
  ]
}

module "kms_key_s3_bucket" {
  source = "../custom-modules-examples/kms_key/"

  # Required Parameters
  iam_roles = [module.iam_role.arn]
  key_name  = "${var.namespace}/${var.environment}/s3_bucket"

  # Optional Parameters
  enable_key_rotation = true
  enable_multi_region = false
}

module "s3_bucket" {
  source = "../custom-modules-examples/s3_bucket/"

  # Required Parameters
  bucket_name = "${var.namespace}-${var.environment}-app1"

  # Optional Paramters
  iam_roles         = [module.iam_role.arn]
  key_arn           = module.kms_key_s3_bucket.arn
  versioning_option = ""

  lifecycle_rules = [{
    id                       = "default"
    status                   = "Enabled"
    expire_days              = 90
    noncurrent_days          = 5
    noncurrent_storage_class = "GLACIER"
    noncurrent_versions      = 2
    transition_days          = 30
    transition_storage_class = "INTELLIGENT_TIERING"
  }]
}

module "elb" {
  source = "../custom-modules-examples/elb/"

  # Required Parameters
  is_internal = false
  lb_type     = "application"
  name        = "${var.namespace}-${var.environment}"
  subnets     = module.vpc.public_subnets[*].id

  # Optional Parameters
  bucket_name                      = ""
  drop_invalid_header_fields       = true
  enable_access_logs               = false
  enable_cross_zone_load_balancing = null
  security_groups                  = [module.alb_security_group.id]

  listeners = [
    {
      certificate_arn   = ""
      listener_port     = 80
      listener_protocol = "HTTP" # HTTP|HTTPS|TCP|TLS
      ssl_policy        = ""     # HTTPS|TLS

      default_action = {
        action_type = "forward" # fixed-response|forward|redirect

        fixed_response = [{
          content_type      = "" # text/plain | text/css | text/html
          fixed_status_code = 0  # 200-500
          message_body      = ""
        }]

        forward = [{
          enable_stickiness   = true # false
          stickiness_duration = 3600 # 3600 seconds / 10 hours
          target_group_arn    = [for group in module.asg.target_groups : group.arn]
          target_group_weight = 0
        }]

        redirect = [{
          redirect_host        = "" # #{host}
          redirect_path        = ""
          redirect_port        = 0  # #{port}
          redirect_protocol    = "" # HTTP|HTTPS|#{protocol}
          redirect_status_code = "" # HTTP_301 | HTTP_302
        }]
      }
    }
  ]
}
