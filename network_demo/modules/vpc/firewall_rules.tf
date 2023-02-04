resource "aws_networkfirewall_rule_group" "stateful" {
  count = var.enable_firewall && length(var.private_subnets) > 0 ? 1 : 0

  capacity = 100
  name     = "default"
  type     = "STATEFUL"

  rule_group {
    rules_source {
      stateful_rule {
        action = "DROP"

        header {
          destination      = "10.0.0.0/8"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "TCP"
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["1"]
        }
      }
      stateful_rule {
        action = "DROP"

        header {
          destination      = "10.0.0.0/8"
          destination_port = "ANY"
          direction        = "ANY"
          protocol         = "ICMP"
          source           = "ANY"
          source_port      = "ANY"
        }

        rule_option {
          keyword  = "sid"
          settings = ["2"]
        }
      }
      stateful_rule {
        action = "PASS"

        header {
          destination      = "ANY"
          destination_port = "ANY"
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
