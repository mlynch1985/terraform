# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_iam_policy_document" "this" {
  statement {
    sid    = "Enable Root User Permissions"
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
      "kms:Tag*",
      "kms:Untag*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
  statement {
    sid    = "Allow VPC Flow Logs to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/vpc/flowlogs/${var.name}"]
    }
  }
}

resource "aws_kms_key" "this" {
  description             = "Used to encrypt VPC Flow Logs in CloudWatch"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.this.json

  tags = {
    "Name" = "vpc_flowlogs_${var.name}"
  }
}

resource "aws_kms_alias" "this" {
  name          = "alias/vpc/flowlogs/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/vpc/flowlogs/${var.name}"
  kms_key_id        = aws_kms_key.this.arn
  retention_in_days = 30
}

resource "aws_iam_role" "this" {
  name_prefix = "vpc_flow_logs_${var.name}_"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "CloudWatch_Logs"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogStream",
            "logs:PutLogEvents",
            "logs:DescribeLogGroups",
            "logs:DescribeLogStreams"
          ]
          Effect   = "Allow"
          Resource = "*"
        }
      ]
    })
  }

  depends_on = [aws_cloudwatch_log_group.this]
}

resource "aws_flow_log" "this" {
  traffic_type             = "ALL"
  iam_role_arn             = aws_iam_role.this.arn
  log_destination          = aws_cloudwatch_log_group.this.arn
  log_format               = var.log_format
  vpc_id                   = var.vpc_id
  max_aggregation_interval = 60

  depends_on = [aws_kms_key.this]
}
