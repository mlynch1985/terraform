# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  common_log_group = "session_manager_log"
}

resource "aws_cloudwatch_log_group" "session_manager_log_region1" {
  name              = "/aws/ssm/${local.common_log_group}"
  retention_in_days = 365
  kms_key_id        = module.session_manager_log_kms_region1.arn

  # CLOUDWATCH-1 = Skipping OPA check requiring KMS key as it is a false positive
  tags = {
    "opa_skip" = "CLOUDWATCH-1"
  }

  provider = aws.region1
}

resource "aws_cloudwatch_log_group" "session_manager_log_region2" {
  name              = "/aws/ssm/${local.common_log_group}"
  retention_in_days = 365
  kms_key_id        = module.session_manager_log_kms_region2.arn

  # CLOUDWATCH-1 = Skipping OPA check requiring KMS key as it is a false positive
  tags = {
    "opa_skip" = "CLOUDWATCH-1"
  }

  provider = aws.region2
}

resource "aws_cloudwatch_log_group" "session_manager_log_region3" {
  name              = "/aws/ssm/${local.common_log_group}"
  retention_in_days = 365
  kms_key_id        = module.session_manager_log_kms_region3.arn

  # CLOUDWATCH-1 = Skipping OPA check requiring KMS key as it is a false positive
  tags = {
    "opa_skip" = "CLOUDWATCH-1"
  }

  provider = aws.region3
}

resource "aws_ssm_parameter" "session_manager_log_region1_arn" {
  name   = "/aft/account/session_manager_log_arn"
  type   = "SecureString"
  value  = aws_cloudwatch_log_group.session_manager_log_region1.arn
  key_id = module.secretsmanager_kms_key_region1.arn

  provider = aws.region1
}

resource "aws_ssm_parameter" "session_manager_log_region2_arn" {
  name   = "/aft/account/session_manager_log_arn"
  type   = "SecureString"
  value  = aws_cloudwatch_log_group.session_manager_log_region2.arn
  key_id = module.secretsmanager_kms_key_region2.arn

  provider = aws.region2
}

resource "aws_ssm_parameter" "session_manager_log_region3_arn" {
  name   = "/aft/account/session_manager_log_arn"
  type   = "SecureString"
  value  = aws_cloudwatch_log_group.session_manager_log_region3.arn
  key_id = module.secretsmanager_kms_key_region3.arn

  provider = aws.region3
}

module "session_manager_log_kms_region1" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.common_log_group}"
  key_policy = data.aws_iam_policy_document.session_manager_log_region1.json

  providers = {
    aws = aws.region1
  }
}

module "session_manager_log_kms_region2" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.common_log_group}"
  key_policy = data.aws_iam_policy_document.session_manager_log_region2.json

  providers = {
    aws = aws.region2
  }
}

module "session_manager_log_kms_region3" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.common_log_group}"
  key_policy = data.aws_iam_policy_document.session_manager_log_region3.json

  providers = {
    aws = aws.region3
  }
}

data "aws_iam_policy_document" "session_manager_log_region1" {
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
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        # Update to reflect desired key administration role - Example: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/MyAdminRole
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html#cmk-permissions
    sid = "Enable CloudWatch Logs to use the key"
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
      identifiers = ["logs.${local.global_vars.region1}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${local.global_vars.region1}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/${local.common_log_group}"]
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

data "aws_iam_policy_document" "session_manager_log_region2" {
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
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        # Update to reflect desired key administration role - Example: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/MyAdminRole
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html#cmk-permissions
    sid = "Enable CloudWatch Logs to use the key"
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
      identifiers = ["logs.${local.global_vars.region2}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${local.global_vars.region2}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/${local.common_log_group}"]
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

data "aws_iam_policy_document" "session_manager_log_region3" {
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
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        # Update to reflect desired key administration role - Example: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/MyAdminRole
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
  }
  statement {
    # https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/encrypt-log-data-kms.html#cmk-permissions
    sid = "Enable CloudWatch Logs to use the key"
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
      identifiers = ["logs.${local.global_vars.region3}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${local.global_vars.region3}:${data.aws_caller_identity.current.account_id}:log-group:/aws/ssm/${local.common_log_group}"]
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
