# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_networkfirewall_rule_group" "stateful" {
  capacity = 100
  name     = "default"
  type     = "STATEFUL"

  rule_group {
    # Define Rule_Groups
    rule_variables {
      port_sets {
        key = "Allowed_Ports"
        port_set {
          definition = ["80", "443"]
        }
      }
    }

    rules_source {
      # Define Public Internet Access
      stateful_rule {
        action = "PASS"

        header {
          destination      = "ANY"
          destination_port = "$Allowed_Ports"
          direction        = "ANY"
          protocol         = "IP"
          source           = "ANY"
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
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }

      # Define Cross VPC Allows
      stateful_rule {
        action = "PASS"

        header {
          destination      = var.tgw_cidr_route
          destination_port = "80"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["3"]
        }
      }
    }
  }
}
