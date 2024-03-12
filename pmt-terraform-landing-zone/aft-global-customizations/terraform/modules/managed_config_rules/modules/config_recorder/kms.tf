# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_kms_key" "this" {
  enable_key_rotation     = true
  deletion_window_in_days = 30
  multi_region            = false
  policy                  = ""
}

resource "aws_kms_alias" "this" {
  name          = "alias/aft_config_recorder_${data.aws_region.current.name}"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = data.aws_iam_policy_document.kms.json
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable IAM User Permissions"
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
    resources = [aws_kms_key.this.arn]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "AWSConfigKMSPolicy"
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [aws_kms_key.this.arn]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }
  }
}
