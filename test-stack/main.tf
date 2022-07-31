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
  source = "github.com/mlynch1985/terraform/custom-modules-examples/ipam/"

  allocation_default_netmask_length = 20
  allocation_max_netmask_length     = 28
  allocation_min_netmask_length     = 16
  ipam_cidr                         = "10.0.0.0/8"
}

/* ToDo: Integrate IPAM with VPC Module */
module "vpc" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/vpc/"

  namespace         = var.namespace
  environment       = var.environment
  ipam_pool_id      = module.ipam.pool_id
  ipam_pool_netmask = "20"
  # cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  subnet_size_offset   = 8
  target_az_count      = 3
  tgw_id               = ""
  vpc_type             = "hub"
}

/* ToDo: Implement ManagedPolicy ARNs and Inline Policy Attachements */
module "iam_role" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/iam_role/"

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

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
}

module "kms_key_asg" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/kms_key/"

  key_name            = "${var.namespace}/${var.environment}/asg"
  iam_roles           = [module.iam_role.arn, "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  enable_multi_region = false

  depends_on = [
    aws_iam_service_linked_role.autoscaling
  ]
}

/* ToDo: Create as a reusable module */
resource "aws_security_group" "asg" {
  lifecycle {
    create_before_destroy = true
  }

  name_prefix = "${var.namespace}-${var.environment}-ec2"
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc.id

  ingress {
    description = "Allow inbound HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.namespace}-${var.environment}-ec2"
  }
}

module "asg" {
  source = "github.com/mlynch1985/terraform/custom-modules-examples/asg/"

  # Required Parameters
  image_id               = data.aws_ami.amazonlinux2.id
  instance_type          = "c5.xlarge"
  kms_key_arn            = module.kms_key_asg.arn
  server_name            = "app_server"
  subnets                = module.vpc.private_subnets[*].id
  vpc_security_group_ids = [module.vpc.default_security_group.id, aws_security_group.asg.id]

  # Optional Parameters
  desired_capacity         = 3
  healthcheck_grace_period = 300
  healthcheck_type         = "EC2"
  iam_instance_profile     = module.iam_role.profile
  max_size                 = 6
  min_size                 = 1

  block_device_mappings = [
    {
      device_name : "/dev/xvda"
      volume_type : "gp3"
      volume_size : "50"
      iops : "3000"
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

  # Local File User Data Script
  # user_data = filebase64("userdata.sh")
}

# module "kms_key_s3_bucket" {
#   source = "github.com/mlynch1985/terraform/custom-modules-examples/kms_key/"

#   key_name            = "${var.namespace}/${var.environment}/s3_bucket"
#   iam_roles           = [module.iam_role.arn]
#   enable_multi_region = false
# }

# module "s3_bucket" {
#   source = "github.com/mlynch1985/terraform/custom-modules-examples/s3_bucket/"

#   bucket_name = "${var.namespace}-${var.environment}-app1"
#   key_arn     = module.kms_key_s3_bucket.arn
#   iam_roles   = [module.iam_role.arn]
# }

/* ToDo: Implement public load balancers */
