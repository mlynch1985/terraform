# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_networkfirewall_rule_group" "stateful" {
  count = var.firewall_enabled == true ? 1 : 0

  capacity = 100
  name     = "default"
  type     = "STATEFUL"

  encryption_configuration {
    key_id = aws_kms_key.net_fw_key[0].arn
    type   = "CUSTOMER_KMS"
  }

  rule_group {
    rule_variables {
      port_sets {
        key = "Internal_Allowed_Ports"
        port_set {
          definition = [
            "22",  # SSH
            "53",  # DNS
            "123", # NTP
            "80",  # HTTP
            "443", # HTTPS
            "3389" # RDP
          ]
        }
      }
      port_sets {
        key = "External_Allowed_Ports"
        port_set {
          definition = [
            "53",  # DNS
            "123", # NTP
            "80",  # HTTP
            "443"  # HTTPS
          ]
        }
      }
    }

    rules_source {
      # Define Cross VPC Allows
      stateful_rule {
        action = "PASS"

        header {
          destination      = var.tgw_cidr_route
          destination_port = "$Internal_Allowed_Ports"
          direction        = "ANY"
          protocol         = "IP"
          source           = var.tgw_cidr_route
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }

      # Define Cross VPC Blocks
      stateful_rule {
        action = "DROP"

        header {
          destination      = var.tgw_cidr_route
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "IP"
          source           = var.tgw_cidr_route
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }

      # Define Public Internet Allows
      stateful_rule {
        action = "PASS"

        header {
          destination      = "ANY"
          destination_port = "$External_Allowed_Ports"
          direction        = "ANY"
          protocol         = "IP"
          source           = var.tgw_cidr_route
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["3"]
        }
      }

      # Define Public Internet Blocks
      stateful_rule {
        action = "DROP"

        header {
          destination      = "ANY"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "IP"
          source           = var.tgw_cidr_route
          source_port      = "ANY"
        }
        rule_option {
          keyword  = "sid"
          settings = ["4"]
        }
      }
    }
  }
}
