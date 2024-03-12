# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  cmk_name = "networkfirewall_cmk"
}

module "networkfirewall_kms_key_region1" {
  source = "../../modules/kms_key"

  key_name   = "networkfirewall/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.networkfirewall_kms_key.json

  providers = {
    aws = aws.region1
  }
}

module "networkfirewall_kms_key_region2" {
  source = "../../modules/kms_key"

  key_name   = "networkfirewall/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.networkfirewall_kms_key.json

  providers = {
    aws = aws.region2
  }
}

module "networkfirewall_kms_key_region3" {
  source = "../../modules/kms_key"

  key_name   = "networkfirewall/${local.cmk_name}"
  key_policy = data.aws_iam_policy_document.networkfirewall_kms_key.json

  providers = {
    aws = aws.region3
  }
}

data "aws_iam_policy_document" "networkfirewall_kms_key" {
  #checkov:skip=CKV_AWS_109:Condition is restricting to accounts only within the organizations or aws service principal.
  #checkov:skip=CKV_AWS_111:Condition is restricting to accounts only within the organizations.
  #checkov:skip=CKV_AWS_356:Policy is required attibute for the module and unknown at the time during creation.

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
    sid = "Enable Network Firewall to use the key"
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
      identifiers = ["network-firewall.amazonaws.com"]
    }
  }
  statement {
    sid = "Allow attachment of persistent resources"
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }
}
