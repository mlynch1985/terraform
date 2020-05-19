## Allow HTTP inbound traffic from Home Office
resource "aws_security_group" "allow-remote-http" {
  name        = "allow-remote-http"
  description = "Allow HTTP inbound traffic from Home Office"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow HTTP inbound traffic from Home Office"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.office-ip}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}-allow-remote-http"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow MySQL inbound traffic from Private Servers
resource "aws_security_group" "allow-vpc-mysql" {
  name        = "allow-vpc-mysql"
  description = "Allow MySQL inbound traffic from Private Servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description     = "Allow MySQL inbound traffic from Private Servers"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [for s in data.aws_subnet.private-subnets-list : s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}-allow-remote-http"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
