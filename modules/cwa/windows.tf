resource "aws_ssm_parameter" "windows_parameter" {
  count = var.platform == "windows" ? 1 : 0

  name        = "/${var.namespace}/${var.app_role}/cwa_windows_config"
  type        = "String"
  description = "CloudWatch Agent configuration file for Wnidows servers"
  overwrite   = true

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_cwa_windows"
    )
  )

  value = var.config_json
}


resource "aws_cloudwatch_metric_alarm" "windows_high_cpu" {
  count = var.platform == "windows" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "Processor % Processor Time"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # % Utilized
  alarm_description   = "This metric alarm tracks CPU usage above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_cpu"
  }
}

resource "aws_cloudwatch_metric_alarm" "windows_low_disk_space" {
  count = var.platform == "windows" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_low_disk_space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "LogicalDisk % Free Space"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 20 # 80% full
  alarm_description   = "This metric alarm tracks disk usage above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_low_disk_space"
  }
}

resource "aws_cloudwatch_metric_alarm" "windows_high_disk_read_time" {
  count = var.platform == "windows" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_disk_read_time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "% Disk Read Time"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # % time busy
  alarm_description   = "This metric alarm tracks disk read time above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_disk_read_time"
  }
}

resource "aws_cloudwatch_metric_alarm" "windows_high_disk_write_time" {
  count = var.platform == "windows" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_disk_write_time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "% Disk Write Time"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 80 # % time busy
  alarm_description   = "This metric alarm tracks disk write time above 80% over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_disk_write_time"
  }
}

resource "aws_cloudwatch_metric_alarm" "windows_high_memory" {
  count = var.platform == "windows" ? 1 : 0

  alarm_name          = "${var.namespace}_${var.app_role}_high_memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "Memory Available MBytes"
  namespace           = "${var.namespace}_${var.app_role}"
  period              = 60 # seconds
  statistic           = "Average"
  threshold           = 500 # MB availble
  alarm_description   = "This metric alarm tracks memory availble below 500MB over 5 minutes"
  tags = {
    Name = "${var.namespace}_${var.app_role}_high_memory"
  }
}
