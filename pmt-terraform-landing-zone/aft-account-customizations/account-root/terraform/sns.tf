# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  name = "aws-controltower-SecurityNotifications"
}

module "securitynotification_sns_region1" {
  source = "../../modules/sns"

  name              = local.name
  display_name      = local.name
  kms_master_key_id = module.sns_kms_key_region1.id
  tracing_config    = "Active"

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    cwe = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }

    publish_alarm = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["cloudwatch.amazonaws.com"]
      }]
    }
  }

  tags = {}

  providers = {
    aws = aws.region1
  }
}

module "securitynotification_sns_region2" {
  source = "../../modules/sns"

  name              = local.name
  display_name      = local.name
  kms_master_key_id = module.sns_kms_key_region2.id
  tracing_config    = "Active"

  create_topic_policy         = true
  enable_default_topic_policy = true
  topic_policy_statements = {
    cwe = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["events.amazonaws.com"]
      }]
    }

    publish_alarm = {
      actions = ["sns:Publish"]
      principals = [{
        type        = "Service"
        identifiers = ["cloudwatch.amazonaws.com"]
      }]
    }
  }

  tags = {}

  providers = {
    aws = aws.region2
  }
}

module "sns_kms_key_region1" {
  source = "../../modules/kms_key"

  key_name   = "sns/${local.name}"
  key_policy = data.aws_iam_policy_document.sns_kms_key.json

  providers = {
    aws = aws.region1
  }
}

module "sns_kms_key_region2" {
  source = "../../modules/kms_key"

  key_name   = "sns/${local.name}"
  key_policy = data.aws_iam_policy_document.sns_kms_key.json

  providers = {
    aws = aws.region2
  }
}

data "aws_iam_policy_document" "sns_kms_key" {

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
    sid = "Enable SNS to use the key"
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
      identifiers = ["sns.amazonaws.com"]
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
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
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
      values   = [data.aws_organizations_organization.this.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}
