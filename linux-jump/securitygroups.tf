## Allow SSH inbound traffic from Home Office
resource "aws_security_group" "allow-remote-ssh" {
  name        = "allow-remote-ssh"
  description = "Allow SSH inbound traffic from Home Office"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow SSH inbound traffic from Home Office"
    from_port   = 22
    to_port     = 22
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
    Name        = "${var.namespace}-allow-remote-ssh"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
