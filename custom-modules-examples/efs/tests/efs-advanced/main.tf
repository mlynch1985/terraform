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
    sid    = "Enable EFS Service"
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
      identifiers = ["*"]
    }
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["elasticfilesystem.${var.region}.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_kms_key" "tester" {
  description             = "EFS Tester"
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

  enable_lifecycle_policy = true
  iam_roles               = [aws_iam_role.tester.arn]
  kms_key_arn             = aws_kms_key.tester.arn
  performance_mode        = "generalPurpose"
  provisioned_throughput  = 125
  security_groups         = [aws_security_group.tester.id]
  subnets                 = data.aws_subnets.tester.ids
  throughput_mode         = "provisioned"
}
