# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

######################################
#####     Network FW KMS Key     #####
######################################

resource "aws_kms_key" "net_fw_key" {
  count = var.firewall_enabled == true ? 1 : 0

  enable_key_rotation = true
  multi_region        = false
  policy              = data.aws_iam_policy_document.net_fw_key[0].json

  tags = {
    Type   = "Inspection"
    Domain = var.domain
  }
}

resource "aws_kms_alias" "net_fw_key" {
  count         = var.firewall_enabled == true ? 1 : 0
  name          = "alias/${var.name}-netfw"
  target_key_id = aws_kms_key.net_fw_key[0].key_id
}

data "aws_iam_policy_document" "net_fw_key" {
  count = var.firewall_enabled == true ? 1 : 0

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
      type = "Service"
      identifiers = [
        "network-firewall.amazonaws.com",
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }
}

########################################
#####     CW Log Group KMS Key     #####
########################################

resource "aws_kms_key" "fw_loggroup" {
  count = var.firewall_enabled == true ? 1 : 0

  description             = "Used to encrypt AWS Firewall Logs in CloudWatch"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.fw_loggroup[0].json

  tags = {
    "Name" = "${var.name}_firewall_logs"
    Type   = "Inspection"
    Domain = var.domain
  }
}

resource "aws_kms_alias" "fw_loggroup" {
  count         = var.firewall_enabled == true ? 1 : 0
  name          = "alias/firewall/logs/${var.name}"
  target_key_id = aws_kms_key.fw_loggroup[0].key_id
}

data "aws_iam_policy_document" "fw_loggroup" {
  count = var.firewall_enabled == true ? 1 : 0

  statement {
    sid    = "Enable Root User Permissions"
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
      "kms:Tag*",
      "kms:Untag*",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid    = "Allow AWS Firewall Logs to use the key"
    effect = "Allow"
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    principals {
      type = "Service"
      identifiers = [
        "network-firewall.amazonaws.com",
        "logs.${data.aws_region.current.name}.amazonaws.com"
      ]
    }
  }
}
