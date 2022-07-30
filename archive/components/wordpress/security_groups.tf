resource "aws_security_group" "efs" {
  name_prefix = "${local.namespace}_${local.component}_efs_"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    protocol        = "tcp"
    from_port       = 2049
    to_port         = 2049
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
      "Name", "${local.namespace}/${local.component}/efs"
    )
  )
}

resource "aws_security_group" "alb" {
  name_prefix = "${local.namespace}_${local.component}_alb_"
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
      "Name", "${local.namespace}/${local.component}/alb"
    )
  )
}

resource "aws_security_group" "asg" {
  name_prefix = "${local.namespace}_${local.component}_asg_"
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
      "Name", "${local.namespace}/${local.component}/asg"
    )
  )
}

resource "aws_security_group" "rds" {
  name_prefix = "${local.namespace}_${local.component}_rds_"
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
      "Name", "${local.namespace}/${local.component}/rds"
    )
  )
}