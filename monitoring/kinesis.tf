## Create Kinesis Stream for Cloudwatch Logs
resource "aws_kinesis_stream" "windows_eventlogs" {
  name             = "${var.namespace}_windows_eventlogs"
  shard_count      = 1
  retention_period = 24

  tags = {
    Name        = "${var.namespace}_windows_eventlogs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Log Subcription Filter to push into Kinesis Data Stream
resource "aws_cloudwatch_log_subscription_filter" "windows_eventlogs" {
  name            = "${var.namespace}_windows_eventlogs"
  role_arn        = aws_iam_role.subscription_filter_windows_eventlogs.arn
  log_group_name  = "${var.namespace}_windows_eventlogs"
  filter_pattern  = ""
  destination_arn = aws_kinesis_stream.windows_eventlogs.arn
  distribution    = "Random"
}
