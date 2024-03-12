# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  access_log_bucket_name = "common"
}

module "account_s3_access_log_bucket_region1" {
  source              = "./modules/s3_bucket/access_log"
  bucket_name         = local.access_log_bucket_name
  access_logs_key_arn = module.account_kms_key_region1.arn
  tags                = {}

  providers = {
    aws = aws.region1
  }
}

module "account_s3_access_log_bucket_region2" {
  source              = "./modules/s3_bucket/access_log"
  bucket_name         = local.access_log_bucket_name
  access_logs_key_arn = module.account_kms_key_region2.arn

  providers = {
    aws = aws.region2
  }
}

module "account_s3_access_log_bucket_region3" {
  source              = "./modules/s3_bucket/access_log"
  bucket_name         = local.access_log_bucket_name
  access_logs_key_arn = module.account_kms_key_region3.arn

  providers = {
    aws = aws.region3
  }
}

resource "aws_ssm_parameter" "account_s3_access_log_bucket_region1_arn" {
  name   = "/aft/account/account_s3_access_log_bucket_arn"
  type   = "SecureString"
  value  = module.account_s3_access_log_bucket_region1.arn
  key_id = module.secretsmanager_kms_key_region1.arn

  provider = aws.region1
}

resource "aws_ssm_parameter" "account_s3_access_log_bucket_region2_arn" {
  name   = "/aft/account/account_s3_access_log_bucket_arn"
  type   = "SecureString"
  value  = module.account_s3_access_log_bucket_region2.arn
  key_id = module.secretsmanager_kms_key_region2.arn

  provider = aws.region2
}

resource "aws_ssm_parameter" "account_s3_access_log_bucket_region3_arn" {
  name   = "/aft/account/account_s3_access_log_bucket_arn"
  type   = "SecureString"
  value  = module.account_s3_access_log_bucket_region3.arn
  key_id = module.secretsmanager_kms_key_region3.arn

  provider = aws.region3
}

module "account_kms_key_region1" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.access_log_bucket_name}_access_logs"
  key_policy = data.aws_iam_policy_document.account_s3_access_log_bucket_kms_key.json

  providers = {
    aws = aws.region1
  }
}

module "account_kms_key_region2" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.access_log_bucket_name}_access_logs"
  key_policy = data.aws_iam_policy_document.account_s3_access_log_bucket_kms_key.json

  providers = {
    aws = aws.region2
  }
}

module "account_kms_key_region3" {
  source = "./modules/kms_key"

  key_name   = "aft/${local.config_bucket_name}_access_logs"
  key_policy = data.aws_iam_policy_document.account_s3_access_log_bucket_kms_key.json

  providers = {
    aws = aws.region3
  }
}

data "aws_iam_policy_document" "account_s3_access_log_bucket_kms_key" {
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
    sid = "Enable S3 Access Logs to use the key"
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
      identifiers = ["logging.s3.amazonaws.com"]
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
