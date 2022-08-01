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

module "ipam" {
  source = "../custom-modules-examples/ipam/"

  # Required Parameters
  ipam_cidr = "10.0.0.0/8"

  # Optional Parameters
  allocation_default_netmask_length = 20
  allocation_max_netmask_length     = 28
  allocation_min_netmask_length     = 16
}

module "vpc" {
  source = "../custom-modules-examples/vpc/"

  # Required Parameters
  environment = var.environment
  namespace   = var.namespace

  # Optional Parameters
  cidr_block           = ""
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  ipam_pool_id         = module.ipam.pool_id
  ipam_pool_netmask    = 20
  subnet_size_offset   = 4
  target_az_count      = 3
  tgw_id               = ""
  vpc_type             = "hub"
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

module "asg_security_group" {
  source = "../custom-modules-examples/security_group/"

  group_name_prefix = "${var.namespace}-${var.environment}-asg"
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
      device_name : "/dev/xvda"
      delete_on_termination : true
      encrypted : true
      iops : 0
      kms_key_id : module.kms_key_asg.arn
      throughput : 0
      volume_type : "gp3"
      volume_size : 50
    },
    {
      device_name : "xvdf"
      delete_on_termination : true
      encrypted : true
      iops : 0
      kms_key_id : module.kms_key_asg.arn
      throughput : 0
      volume_type : "gp3"
      volume_size : 100
    }
  ]

  # Inline User Data Script
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum upgrade -y
    yum install -y httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    EOF
  )
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

/* ToDo: Implement public load balancers */
