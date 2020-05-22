## Allow ElasticSearch inbound traffic from VPC
resource "aws_security_group" "allow_vpc_elasticsearch" {
  name        = "${var.namespace}_allow_vpc_elasticsearch"
  description = "Allow ElasticSearch inbound traffic from VPC"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow ElasticSearch inbound traffic from VPC"
    from_port   = 9200
    to_port     = 9200
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
    Name        = "${var.namespace}_allow_vpc_elasticsearch"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Allow Kibana inbound traffic from VPC
resource "aws_security_group" "allow_vpc_kibana" {
  name        = "${var.namespace}_allow_vpc_kibana"
  description = "Allow Kibana inbound traffic from VPC"
  vpc_id      = data.aws_vpc.vpc.id

  ingress {
    description = "Allow Kibana inbound traffic from VPC"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}_allow_vpc_kibana"
    Environment = var.environment
    Namespace   = var.namespace
  }
}
