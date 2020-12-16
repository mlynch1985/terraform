terraform {
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


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "this" {
  tags = {
    Name = "useast1d_vpc"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    tier = "public"
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.this.id

  tags = {
    tier = "private"
  }
}

data "aws_subnet" "private" {
  for_each = data.aws_subnet_ids.private.ids
  id       = each.value
}

data "aws_ami" "windows_2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}

locals {
  ebs_block_device = [
    {
      device_name = "xvdf"
      volume_type = "gp2"
      volume_size = "50"
    },
    {
      device_name = "xvdg"
      volume_type = "gp2"
      volume_size = "50"
    }
  ]
}

resource "aws_instance" "name" {
  ami           = data.aws_ami.windows_2019.image_id
  instance_type = "t3.medium"
  subnet_id     = tolist(data.aws_subnet_ids.public.ids)[0]

  dynamic "ebs_block_device" {
    for_each = local.ebs_block_device

    content {
      device_name           = lookup(ebs_block_device.value, "device_name", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      encrypted             = lookup(ebs_block_device.value, "encrypted", null)
      kms_key_id            = lookup(ebs_block_device.value, "kms_key_id", null)
    }
  }
}
