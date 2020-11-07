terraform {
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
  name         = var.name
  default_tags = local.default_tags
}

module "alb" {
  source = "../modules/alb"

  namespace         = var.namespace
  name              = var.name
  default_tags      = local.default_tags
  is_internal       = false
  vpc_id            = data.aws_vpc.this.id
  security_groups   = [aws_security_group.alb.id]
  subnets           = data.aws_subnet_ids.public.ids
  enable_stickiness = true
}

module "asg" {
  source = "../modules/asg"

  namespace                  = var.namespace
  name                       = var.name
  default_tags               = local.default_tags
  image_id                   = data.aws_ami.amazon_linux_2.image_id
  instance_type              = "t3.large"
  security_groups            = [aws_security_group.asg.id]
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = true
  iam_instance_profile       = module.ec2_role.profile.arn
  asg_min                    = 3
  asg_max                    = 3
  asg_desired                = 3
  asg_subnets                = data.aws_subnet_ids.private.ids
  target_group_arns          = [module.alb.target_group.arn]
  asg_healthcheck_type       = "ELB"
}

module "rds" {
  source = "../modules/rds"

  namespace          = var.namespace
  name               = var.name
  default_tags       = local.default_tags
  availability_zones = [data.aws_availability_zones.available.names[0],data.aws_availability_zones.available.names[1],data.aws_availability_zones.available.names[2]]
  security_groups    = [aws_security_group.rds.id]
  rds_subnets        = data.aws_subnet_ids.private.ids
}


resource "aws_security_group" "alb" {
  name_prefix = "${var.namespace}_${var.name}_alb"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
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
      "Name", "${var.namespace}_${var.name}_alb"
    )
  )
}

resource "aws_security_group" "asg" {
  name_prefix = "${var.namespace}_${var.name}_asg"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
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
      "Name", "${var.namespace}_${var.name}_asg"
    )
  )
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.namespace}_${var.name}_rds"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.asg.id]
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
      "Name", "${var.namespace}_${var.name}_rds"
    )
  )
}
