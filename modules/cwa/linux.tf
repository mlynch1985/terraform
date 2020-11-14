resource "aws_ssm_parameter" "linux_parameter" {
  count = var.platform == "linux" ? 1 : 0

  name        = "/${var.namespace}/${var.app_role}/cwa_linux_config"
  type        = "String"
  description = "CloudWatch Agent configuration file for Linux servers"
  overwrite   = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_linux"
    )
  )

  value = var.config_json
}

resource "aws_cloudwatch_metric_alarm" "linux_high_cpu" {
  count = var.platform == "linux" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "cpu_usage_active"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # % Utilized
  alarm_description   = "This metric alarm tracks CPU usage above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_cpu"
  }
}

resource "aws_cloudwatch_metric_alarm" "linux_low_disk_space" {
  count = var.platform == "linux" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_low_disk_space"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "disk_used_percent"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # 80% full
  alarm_description   = "This metric alarm tracks disk usage above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_low_disk_space"
  }
}

resource "aws_cloudwatch_metric_alarm" "linux_high_disk_io" {
  count = var.platform == "linux" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_disk_io"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "diskio_io_time"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Sum"
  threshold           = 1000 # milliseconds processing IO requests (1 second)
  alarm_description   = "This metric alarm tracks disk IO time above 1 second over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_disk_io"
  }
}

resource "aws_cloudwatch_metric_alarm" "linux_high_memory" {
  count = var.platform == "linux" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_memory"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "mem_used_percent"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # 80% utilized
  alarm_description   = "This metric alarm tracks memory usage above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_memory"
  }
}
