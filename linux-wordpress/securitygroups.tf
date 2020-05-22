## Allow MySQL inbound traffic from Private Servers
resource "aws_security_group" "allow_vpc_mysql" {
  name        = "${var.namespace}_allow_vpc_mysql"
  description = "Allow MySQL inbound traffic from Private Servers"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow MySQL inbound traffic from Private Servers"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [for s in data.aws_subnet.subnets_private_list : s.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_mysql"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
