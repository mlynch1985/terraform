## Allow RDP inbound traffic from Home Office
resource "aws_security_group" "allow-remote-rdp" {
  name        = "allow-remote-rdp"
  description = "Allow RDP inbound traffic from Home Office"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow RDP inbound traffic from Home Office"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["100.11.168.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}-allow-remote-rdp"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
