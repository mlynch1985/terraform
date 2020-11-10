terraform {
  backend "s3" {
    bucket  = "mltemp-sandbox-tfstate"
    region  = "us-east-1"
    encrypt = true
    key     = "wordpress"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "random" {
  region = var.region
}


module "ec2_role" {
  source = "../modules/ec2_role"

  namespace    = var.namespace
  app_role     = var.app_role
  default_tags = local.default_tags
}

module "msad" {
  source = "../modules/msad"

  namespace           = "useast1d"
  app_role            = "winiis"
  domain_name         = "example.com"
  vpc_id              = data.aws_vpc.this.id
  subnet_1            = tolist(data.aws_subnet_ids.private.ids)[0]
  subnet_2            = tolist(data.aws_subnet_ids.private.ids)[1]
  edition             = "Enterprise"
  enable_sso          = false
  enable_auto_join    = true
  ad_target_tag_name  = "ad_join"
  ad_target_tag_value = "true"
  default_tags        = local.default_tags
}

module "cwa" {
  source = "../modules/cwa"

  namespace    = "useast1d"
  app_role     = "winiis"
  platform     = "windows"
  config_json  = file("${path.module}/cwa_config.json")
  default_tags = local.default_tags
}

module "ec2_instance" {
  source = "../modules/ec2_instance"

  namespace                   = "useast1d"
  app_role                    = "winiis"
  image_id                    = data.aws_ami.windows_2019.image_id
  security_groups             = [aws_security_group.ec2.id]
  subnet_id                   = tolist(data.aws_subnet_ids.public.ids)[0]
  instance_type               = "t3.xlarge"
  key_name                    = ""
  enable_detailed_monitoring  = true
  associate_public_ip_address = true
  user_data                   = filebase64("${path.module}/userdata.ps1")
  iam_instance_profile        = module.ec2_role.profile.name
  enable_second_drive         = true

  default_tags = merge(
    local.default_tags,
    map(
      "ad_join", "true"
    )
  )

  root_block_device = {
    device_name : "/dev/sda1/"
    volume_type : "gp2"
    volume_size : "30"
    delete_on_termination : true
    encrypted : true
  }

  ebs_block_device = {
    device_name : "xvdb"
    volume_type : "gp2"
    volume_size : "50"
    delete_on_termination : false
    encrypted : true
  }
}


resource "aws_iam_role_policy_attachment" "msad" {
  role       = module.ec2_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"

}

resource "aws_security_group" "ec2" {
  name_prefix = "${var.namespace}_${var.app_role}_ec2_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

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
      "Name", "${var.namespace}_${var.app_role}_ec2"
    )
  )
}
