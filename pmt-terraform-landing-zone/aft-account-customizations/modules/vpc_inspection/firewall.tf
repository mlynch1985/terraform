# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_networkfirewall_firewall_policy" "this" {
  name = var.name

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful.arn
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_networkfirewall_firewall" "this" {
  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this.arn
  vpc_id              = aws_vpc.this.id
  delete_protection   = false # for debugging reasons

  dynamic "subnet_mapping" {
    for_each = aws_subnet.private

    content {
      subnet_id = subnet_mapping.value.id
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_networkfirewall_logging_configuration" "this" {
  firewall_arn = aws_networkfirewall_firewall.this.arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_loggroup_alerts.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_loggroup_flowlogs.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }

  depends_on = [aws_kms_key.fw_loggroup]
}

data "aws_iam_policy_document" "fw_loggroup" {
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
    condition {
      test     = "StringEquals"
      variable = "kms:CallerAccount"
      values   = [data.aws_caller_identity.current.account_id]
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
      type        = "Service"
      identifiers = ["logs.${data.aws_region.current.name}.amazonaws.com"]
    }
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/firewall/${var.name}/alert_logs",
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/firewall/${var.name}/flow_logs"
      ]
    }
  }
}

resource "aws_kms_key" "fw_loggroup" {
  description             = "Used to encrypt AWS Firewall Logs in CloudWatch"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.fw_loggroup.json

  tags = {
    "Name" = "${var.name}_firewall_logs"
  }
}

resource "aws_kms_alias" "fw_loggroup" {
  name          = "alias/firewall/logs/${var.name}"
  target_key_id = aws_kms_key.fw_loggroup.key_id
}

resource "aws_cloudwatch_log_group" "fw_loggroup_alerts" {
  name              = "/aws/firewall/${var.name}/alert_logs"
  kms_key_id        = aws_kms_key.fw_loggroup.arn
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "fw_loggroup_flowlogs" {
  name              = "/aws/firewall/${var.name}/flow_logs"
  kms_key_id        = aws_kms_key.fw_loggroup.arn
  retention_in_days = 30
}
