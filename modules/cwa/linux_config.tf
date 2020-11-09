resource "aws_ssm_parameter" "linux" {
  name = "/${var.namespace}/${var.app_role}/cwa_linux_config"
  type = "String"
  description = "CloudWatch Agent configuration file for Linux servers"
  overwrite = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_linux"
    )
  )

  value = <<EOF
{
  "agent": {
    "metrics_collection_interval": 10,
    "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
  },
  "metrics": {
    "namespace": "NAME_SPACE",
    "metrics_collected": {
      "cpu": {
        "measurement": [
          "name": "cpu_usage_idle",
          "cpu_usage_nice",
          "cpu_usage_guest"
        ],
        "resources": ["*"],
        "totalcpu": false
      },
      "disk": {
        "measurement": [
          "free",
          "total",
          "used"
        ],
        "resources": [
          "/",
          "/tmp"
        ],
        "ignore_file_system_types": [
          "sysfs",
          "devtmpfs"
        ]
      },
      "diskio": {
        "measurement": [
          "reads",
          "writes",
          "read_time",
          "write_time",
          "io_time"
        ],
        "resources": ["*"],
      },
      "swap": {
        "measurement": [
          "swap_used",
          "swap_free",
          "swap_used_percent"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used",
          "mem_cached",
          "mem_total"
        ]
      },
      "net": {
        "measurement": [
          "bytes_sent",
          "bytes_recv",
          "drop_in",
          "drop_out"
        ],
        "resources": ["eth0"],
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_syn_sent",
          "tcp_close"
        ]
      },
      "processes": {
        "measurement": [
          "running",
          "sleeping",
          "dead"
        ]
      }
    },
    "force_flush_interval": 30
  }
}
EOF
}
