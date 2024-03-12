# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  cmk_name = "act_secretsmanager_cmk"
}

module "secretsmanager_kms_key_region1" {
  source = "./modules/kms_key"

  key_name   = "secretsmanager/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.secretsmanager_kms_key.json

  providers = {
    aws = aws.region1
  }

}

module "secretsmanager_kms_key_region2" {
  source = "./modules/kms_key"

  key_name   = "secretsmanager/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.secretsmanager_kms_key.json

  providers = {
    aws = aws.region2
  }
}

module "secretsmanager_kms_key_region3" {
  source = "./modules/kms_key"

  key_name   = "secretsmanager/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.secretsmanager_kms_key.json

  providers = {
    aws = aws.region3
  }
}

data "aws_iam_policy_document" "secretsmanager_kms_key" {
  #checkov:skip=CKV_AWS_109:Condition is restricting to accounts only within the organizations or aws service principal.
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.

  statement {
    sid = "Allow access for Key Administrators"
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
      "kms:CancelKeyDeletion",
      "kms:ReplicateKey",
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    sid = "Enable SecretsManager to use the key"
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
      identifiers = ["secretsmanager.amazonaws.com"]
    }
  }
  statement {
    sid = "Enable AWS CT-AFT role to use the key"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AWSAFTExecution"]
    }
  }
  statement {
    sid = "Enable CW to use the key"
    actions = [
      "kms:Decrypt*",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]
    principals {
      type = "Service"
      identifiers = [
        "logs.${local.global_vars.region1}.amazonaws.com",
        "logs.${local.global_vars.region2}.amazonaws.com",
        "logs.${local.global_vars.region3}.amazonaws.com"
      ]
    }
  }
  statement {
    sid       = "EnforceIdentityPerimeter"
    effect    = "Deny"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
  statement {
    sid = "Allow KMS Grants"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::*:role/AWSAFTExecution"]
    }
  }
}
