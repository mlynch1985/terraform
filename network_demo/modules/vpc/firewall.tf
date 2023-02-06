resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name = var.name

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful[0].arn
    }
  }

  tags = {
    Name = var.name
  }
}

resource "aws_networkfirewall_firewall" "this" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name                = var.name
  firewall_policy_arn = aws_networkfirewall_firewall_policy.this[0].arn
  vpc_id              = aws_vpc.this.id

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
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  firewall_arn = aws_networkfirewall_firewall.this[0].arn

  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_loggroup_alerts[0].name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.fw_loggroup_flowlogs[0].name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }

  depends_on = [aws_kms_key.fw_loggroup[0]]
}

data "aws_iam_policy_document" "fw_loggroup" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

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
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  description             = "Used to encrypt AWS Firewall Logs in CloudWatch"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.fw_loggroup[0].json

  tags = {
    "Name" = "firewall_logs_${var.name}"
  }
}

resource "aws_kms_alias" "fw_loggroup" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name          = "alias/firewall/logs/${var.name}"
  target_key_id = aws_kms_key.fw_loggroup[0].key_id
}

resource "aws_cloudwatch_log_group" "fw_loggroup_alerts" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name              = "/aws/firewall/${var.name}/alert_logs"
  kms_key_id        = aws_kms_key.fw_loggroup[0].arn
  retention_in_days = 30
}

resource "aws_cloudwatch_log_group" "fw_loggroup_flowlogs" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  name              = "/aws/firewall/${var.name}/flow_logs"
  kms_key_id        = aws_kms_key.fw_loggroup[0].arn
  retention_in_days = 30
}
