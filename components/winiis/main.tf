terraform {
  backend "s3" {
    bucket         = "useast1d-tf-state"
    key            = "winiis-dev"
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

provider "random" {}

module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace    = local.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "msad" {
  source = "../../modules/msad"

  namespace            = local.namespace
  component            = local.component
  domain_name          = local.domain_name
  vpc_id               = data.aws_vpc.this.id
  subnet_1             = tolist(data.aws_subnet_ids.private.ids)[0]
  subnet_2             = tolist(data.aws_subnet_ids.private.ids)[1]
  edition              = "Enterprise"
  enable_sso           = false
  enable_auto_join     = true
  ad_target_tag_name   = "ad_join"
  ad_target_tag_value  = "true"
  default_tags         = local.default_tags
  iam_instance_profile = module.ec2_role.role.name
}

module "cw_agent" {
  source = "../../modules/cw_agent"

  namespace      = local.namespace
  component      = local.component
  default_tags   = local.default_tags
  iam_role_name  = module.ec2_role.role.name
  windows_config = file("${path.module}/config_windows.json")
}

module "patching" {
  source = "../../modules/patching"

  namespace    = local.namespace
  component    = local.component
  default_tags = local.default_tags
}

module "ec2_instance" {
  source = "../../modules/ec2_instance"

  namespace                   = local.namespace
  component                   = local.component
  image_id                    = data.aws_ami.windows_2019.image_id
  security_groups             = [aws_security_group.ec2.id]
  subnet_id                   = tolist(data.aws_subnet_ids.public.ids)[0]
  instance_type               = local.instance_type
  key_name                    = ""
  enable_detailed_monitoring  = false
  associate_public_ip_address = true
  user_data                   = filebase64("${path.module}/userdata.ps1")
  iam_instance_profile        = module.ec2_role.profile.name
  enable_second_drive         = true

  default_tags = merge(
    local.default_tags,
    map(
      "ad_join", "true",
      "enable_patching", "true"
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


resource "aws_security_group" "ec2" {
  name_prefix = "${local.namespace}_${local.component}_ec2_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
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
      "Name", "${local.namespace}_${local.component}_ec2"
    )
  )
}
