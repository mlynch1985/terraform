# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_caller_identity" "current" {}
data "aws_organizations_organization" "current" {}

resource "aws_kms_key" "this" {
  description             = "This CMK is used to encrypt all resources within the current account and region"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 30
  is_enabled              = true
  enable_key_rotation     = true
  multi_region            = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/account-key"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow access for Key Administrators"
        Effect = "Allow"
        Action = [
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
          "kms:CancelKeyDeletion",
          "kms:ReplicateKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*"
        ]
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSAFTExecution",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin"
          ]
        }
        Resource = aws_kms_key.this.arn
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant",
          "kms:ListGrants",
          "kms:RevokeGrant"
        ]
        Principal = {
          AWS = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSAFTExecution",
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
        }
        Resource = aws_kms_key.this.arn
      }
    ]
  })
}
