# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_networkfirewall_firewall" "this" {
  count = var.firewall_enabled == true ? 1 : 0

  name                     = replace(var.name, "_", "-")
  delete_protection        = var.firewall_delete_protection
  description              = "Integrated with the ${var.name} VPC"
  firewall_policy_arn      = aws_networkfirewall_firewall_policy.this[0].arn
  subnet_change_protection = true
  vpc_id                   = aws_vpc.this.id

  dynamic "subnet_mapping" {
    for_each = aws_subnet.private

    content {
      subnet_id = subnet_mapping.value.id
    }
  }

  encryption_configuration {
    key_id = aws_kms_key.net_fw_key[0].arn
    type   = "CUSTOMER_KMS"
  }

  tags = {
    Name   = var.name
    Type   = "Inspection"
    Domain = var.domain
  }
}

resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.firewall_enabled == true ? 1 : 0

  name        = replace(var.name, "_", "-")
  description = "Integrated with the ${var.name} VPC"

  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]

    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.stateful[0].arn
    }
  }

  encryption_configuration {
    key_id = aws_kms_key.net_fw_key[0].arn
    type   = "CUSTOMER_KMS"
  }

  tags = {
    Name = var.name
  }
}

resource "aws_networkfirewall_logging_configuration" "this" {
  count = var.firewall_enabled == true ? 1 : 0

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

resource "aws_cloudwatch_log_group" "fw_loggroup_alerts" {
  count = var.firewall_enabled == true ? 1 : 0

  name              = "/aws/firewall/${var.name}/alert_logs"
  kms_key_id        = aws_kms_key.fw_loggroup[0].arn
  retention_in_days = 365

  tags = {
    Type   = "Inspection"
    Domain = var.domain
  }
}

resource "aws_cloudwatch_log_group" "fw_loggroup_flowlogs" {
  count = var.firewall_enabled == true ? 1 : 0

  name              = "/aws/firewall/${var.name}/flow_logs"
  kms_key_id        = aws_kms_key.fw_loggroup[0].arn
  retention_in_days = 365

  tags = {
    Type   = "Inspection"
    Domain = var.domain
  }
}
