## Allow SSH inbound traffic from VPC
resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
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
    Name        = "${var.namespace}-allow-ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow RDP inbound traffic from VPC
resource "aws_security_group" "allow_rdp" {
  name        = "allow-rdp"
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
    Name        = "${var.namespace}-allow-rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow HTTP inbound traffic from VPC
resource "aws_security_group" "allow_http" {
  name        = "allow-http"
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
    Name        = "${var.namespace}-allow-http"
    Environment = var.environment
    Namespace   = var.namespace
  }
}


## Allow HTTPS inbound traffic from VPC
resource "aws_security_group" "allow_https" {
  name        = "allow-https"
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
    Name        = "${var.namespace}-allow-https"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
