terraform {
  backend "s3" {
    bucket         = "useast1d-tf-state"
    key            = "elk-dev"
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

module "ec2_role" {
  source = "../../modules/ec2_role"

  namespace    = local.namespace
  component    = local.component
  default_tags = local.default_tags
}

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
      volume_size : "50"
      iops : null
      delete_on_termination : true
      encrypted : true
    }
  ]
}

resource "aws_security_group" "ec2" {
  name_prefix = "${local.namespace}_${local.component}_ec2_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 5601
    to_port     = 5601
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
