# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  common_kms_key = "common_kms_key"
}

module "common_kms_key_region1" {
  source = "./modules/kms_key"

  key_name            = "aft/${local.common_kms_key}"
  key_policy          = data.aws_iam_policy_document.common_kms_key.json
  enable_multi_region = true

  providers = {
    aws = aws.region1
  }
}

module "common_kms_key_replica_region2" {
  source = "./modules/kms_key_replica"

  key_name        = "aft/${local.common_kms_key}"
  key_policy      = data.aws_iam_policy_document.common_kms_key.json
  primary_key_arn = module.common_kms_key_region1.arn

  providers = {
    aws = aws.region2
  }
}

module "common_kms_key_replica_region3" {
  source = "./modules/kms_key_replica"

  key_name        = "aft/${local.common_kms_key}"
  key_policy      = data.aws_iam_policy_document.common_kms_key.json
  primary_key_arn = module.common_kms_key_region1.arn

  providers = {
    aws = aws.region3
  }
}

resource "aws_ssm_parameter" "kms_region1_arn" {
  name   = "/aft/account/kms_arn"
  type   = "SecureString"
  value  = module.common_kms_key_region1.arn
  key_id = module.secretsmanager_kms_key_region1.arn

  provider = aws.region1
}

resource "aws_ssm_parameter" "kms_region2_arn" {
  name   = "/aft/account/kms_arn"
  type   = "SecureString"
  value  = module.common_kms_key_replica_region2.arn
  key_id = module.secretsmanager_kms_key_region2.arn

  provider = aws.region2
}

resource "aws_ssm_parameter" "kms_region3_arn" {
  name   = "/aft/account/kms_arn"
  type   = "SecureString"
  value  = module.common_kms_key_replica_region3.arn
  key_id = module.secretsmanager_kms_key_region3.arn

  provider = aws.region3
}

data "aws_iam_policy_document" "common_kms_key" {
  #checkov:skip=CKV_AWS_109:Condition is restricting to accounts only within the organizations or aws service principal.
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.
  statement {
    sid = "Allow Use of KMS"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
      "kms:GenerateDataKey",
      "kms:Decrypt"
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
}
