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
  name_prefix           = "efs_tester_"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "tester" {
  name_prefix = "efs_tester_"
  role        = aws_iam_role.tester.id
}

resource "aws_security_group" "tester" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  name_prefix = "efs_tester_"
  description = "SG Used to test the EFS Terraform Module"
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
    Name = "efs_tester"
  }
}

module "efs" {
  source = "../../../../custom-modules-examples/efs"

  iam_roles       = [aws_iam_role.tester.arn]
  security_groups = [aws_security_group.tester.id]
  subnets         = data.aws_subnets.tester.ids
}
