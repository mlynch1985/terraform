resource "aws_ssm_parameter" "windows" {
  name = "/${var.namespace}/${var.app_role}/cwa_windows_config"
  type = "String"
  description = "CloudWatch Agent configuration file for Wnidows servers"
  overwrite = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_windows"
    )
  )

  value = <<EOF
{
  "agent": {
    "metrics_collection_interval": 10,
    "logfile": "C:\\ProgramData\\Amazon\\AmazonCloudWatchAgent\\Logs\\amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "NAMESPACE",
    "metrics_collected": {
      "Processor": {
        "measurement": [
          "% Idle Time",
          "% Interrupt Time",
          "% User Time",
          "% Processor Time"
        ],
        "resources": ["*"]
      },
      "LogicalDisk": {
        "measurement": [
          "% Idle Time",
          "% Disk Read Time",
          "% Disk Write Time"
        ],
        "resources": ["*"]
      },
      "Memory": {
        "measurement": [
          "Available Bytes",
          "Cache Faults/sec",
          "Page Faults/sec",
          "Pages/sec"
        ]
      },
      "Network Interface": {
        "measurement": [
          "Bytes Received/sec",
          "Bytes Sent/sec",
          "Packets Received/sec",
          "Packets Sent/sec"
        ],
        "resources": ["*"]
      },
      "System": {
        "measurement": [
          "Context Switches/sec",
          "System Calls/sec",
          "Processor Queue Length"
        ]
      }
    }
  }
}
EOF
}
