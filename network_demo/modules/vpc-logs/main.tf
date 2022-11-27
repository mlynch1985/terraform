data "aws_caller_identity" "current" {}

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
    sid    = "Enable CloudWatch Logs"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    principals {
      type        = "Service"
      identifiers = ["logs.${var.region}.amazonaws.com"]
    }
    resources = ["*"]
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"]
    }
  }
}

resource "aws_kms_key" "vpc_flow_logs" {
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}

resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/vpc/flow-logs/${var.region}"
  retention_in_days = 30
  kms_key_id        = aws_kms_key.vpc_flow_logs.arn
}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vpc_flow_logs" {
  name_prefix        = "vpc-flow-logs-${var.region}"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy" "vpc_flow_logs" {
  name_prefix = "vpc-flow-logs-${var.region}"
  role        = aws_iam_role.vpc_flow_logs.id

  #tfsec:ignore:aws-iam-no-policy-wildcards
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "GrantCloudWatchLogs"
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.vpc_flow_logs.arn}*"
    }]
  })
}

resource "aws_flow_log" "vpc_flow_logs" {
  count = length(var.vpc_ids)

  iam_role_arn    = aws_iam_role.vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_logs.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_ids[count.index]
}
