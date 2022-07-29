data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "kms_key_policy" {
  #checkov:skip=CKV_AWS_109:We are enabling access via IAM Roles and Users
  #checkov:skip=CKV_AWS_111:We are enabling access via IAM Roles and Users
  statement {
    sid       = "Enable IAM User Permissions"
    resources = ["*"]
    actions   = ["kms:*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid       = "Enable Specific Roles to use this key"
    resources = ["*"]
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    principals {
      type        = "AWS"
      identifiers = var.iam_roles
    }
  }
}

resource "aws_kms_key" "kms_key" {
  deletion_window_in_days = 30
  enable_key_rotation     = true
  multi_region            = var.enable_multi_region
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${var.key_name}"
  target_key_id = aws_kms_key.kms_key.key_id
}
