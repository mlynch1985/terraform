## Allow SSH inbound traffic from VPC
resource "aws_security_group" "allow_vpc_ssh" {
  name        = "${var.namespace}_allow_vpc_ssh"
  description = "Allow SSH inbound traffic from VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH inbound traffic from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow RDP inbound traffic from VPC
resource "aws_security_group" "allow_vpc_rdp" {
  name        = "${var.namespace}_allow_vpc_rdp"
  description = "Allow RDP inbound traffic from VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow RDP inbound traffic from VPC"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow HTTP inbound traffic from VPC
resource "aws_security_group" "allow_vpc_http" {
  name        = "${var.namespace}_allow_vpc_http"
  description = "Allow HTTP inbound traffic from VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP inbound traffic from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_http"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow HTTPS inbound traffic from VPC
resource "aws_security_group" "allow_vpc_https" {
  name        = "${var.namespace}_allow_vpc_https"
  description = "Allow HTTPS inbound traffic from VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTPS inbound traffic from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_https"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow SSH inbound traffic from Office
resource "aws_security_group" "allow_office_ssh" {
  name        = "${var.namespace}_allow_office_ssh"
  description = "Allow SSH inbound traffic from Office"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH inbound traffic from Office"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.office_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_office_ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow RDP inbound traffic from Office
resource "aws_security_group" "allow_office_rdp" {
  name        = "${var.namespace}_allow_office_rdp"
  description = "Allow RDP inbound traffic from Office"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow RDP inbound traffic from Office"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.office_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_office_rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow HTTP inbound traffic from Office
resource "aws_security_group" "allow_office_http" {
  name        = "${var.namespace}_allow_office_http"
  description = "Allow HTTP inbound traffic from Office"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP inbound traffic from Office"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.office_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_office_http"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow HTTPS inbound traffic from Office
resource "aws_security_group" "allow_office_https" {
  name        = "${var.namespace}_allow_office_https"
  description = "Allow HTTPS inbound traffic from Office"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow HTTPS inbound traffic from Office"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.office_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_office_https"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
