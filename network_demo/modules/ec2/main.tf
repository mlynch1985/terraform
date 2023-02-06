data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name_prefix           = "ec2_role_${data.aws_region.current.name}_"
  assume_role_policy    = data.aws_iam_policy_document.trust_policy.json
  force_detach_policies = true
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = "ec2_role_${data.aws_region.current.name}_"
  role        = aws_iam_role.this.id
}

resource "aws_security_group" "this" {
  vpc_id      = var.vpc_id
  description = "Network Demo Security Group"

  ingress {
    description = "Allow ICMP"
    from_port   = 6
    to_port     = 6
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  }

  tags = {
    Name = "Network-Demo"
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazonlinux2.id
  associate_public_ip_address = false
  ebs_optimized               = true
  iam_instance_profile        = aws_iam_instance_profile.this.name
  instance_type               = "t3.small"
  monitoring                  = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted   = true
    volume_size = 16
    volume_type = "gp3"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum install -y httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    EOF
  )

  tags = {
    Name = "Network-Demo"
  }
}
