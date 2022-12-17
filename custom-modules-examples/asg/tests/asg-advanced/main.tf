data "aws_iam_policy_document" "kms_key_policy" {
  #checkov:skip=CKV_AWS_109:Ensure IAM policies does not allow permissions management / resource exposure without constraints
  #checkov:skip=CKV_AWS_111:Ensure IAM policies does not allow write access without constraints

  statement {
    sid    = "Enable Admin Management"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    resources = ["*"]
  }
  statement {
    sid    = "Enable AutoScalingServiceRole"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*",
      "kms:CreateGrant"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    }
    resources = ["*"]
  }
}

resource "aws_kms_key" "tester" {
  description             = "ASG Tester"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "tester" {
  assume_role_policy    = data.aws_iam_policy_document.trust_policy.json
  force_detach_policies = true
  name_prefix           = "asg_tester_"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "tester" {
  name_prefix = "asg_tester_"
  role        = aws_iam_role.tester.id
}

resource "aws_security_group" "tester" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  name_prefix = "asg_tester_"
  description = "SG Used to test the ASG Terraform Module"
  vpc_id      = var.vpc_id

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "asg_tester"
  }
}

module "asg" {
  source = "../../../../custom-modules-examples/asg"

  block_device_mappings = [
    {
      device_name           = "/dev/xvda"
      delete_on_termination = true
      encrypted             = true
      iops                  = "3000"
      kms_key_id            = aws_kms_key.tester.arn
      throughput            = "125"
      volume_size           = "50"
      volume_type           = "gp3"
    },
    {
      device_name           = "xvdf"
      delete_on_termination = true
      encrypted             = true
      iops                  = "3000"
      kms_key_id            = aws_kms_key.tester.arn
      throughput            = "500"
      volume_size           = "250"
      volume_type           = "gp3"
    }
  ]

  healthcheck_grace_period = 300
  healthcheck_type         = "EC2"
  iam_instance_profile     = aws_iam_instance_profile.tester.name
  image_id                 = data.aws_ami.amazonlinux2.id
  instance_type            = "c5.large"
  max_size                 = 1
  min_size                 = 1
  server_name              = "asg_module_tester"
  subnets                  = data.aws_subnets.tester.ids
  security_group_ids       = [aws_security_group.tester.id]

  target_groups = {
    "group_1" = {
      deregistration_delay  = 30
      enable_healthcheck    = true
      enable_stickiness     = true
      group_port            = 80
      group_protocol        = "HTTP"
      health_check_interval = 30
      health_check_matcher  = "200-399"
      health_check_path     = "/"
      health_check_port     = 80
      health_check_protocol = "HTTP"
      health_check_timeout  = 5
      healthy_threshold     = 3
      stickiness_type       = "lb_cookie"
      target_type           = "instance"
      unhealthy_threshold   = 3
      vpc_id                = var.vpc_id
    }
  }

  # Inline User Data Script
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum upgrade -y
    yum install -y httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    EOF
  )
}
