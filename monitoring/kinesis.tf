## Create our Kinesis Data Stream
resource "aws_kinesis_stream" "kinesis-logs-stream" {
  name                      = "${var.namespace}-cloudwatch-logs"
  shard_count               = 1
  retention_period          = 48 ## Hours
  enforce_consumer_deletion = true
  encryption_type           = "KMS"
  kms_key_id                = aws_kms_key.kms-key-kinesis.id

  tags = {
    Name        = "${var.namespace}-cloudwatch-logs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Create Cloudwatch Log Subscription Filter
resource "aws_cloudwatch_log_subscription_filter" "kinesis-cloudwatch-subscription-filter" {
  name            = "${var.namespace}-kinesis-filter"
  role_arn        = aws_iam_role.role-cloudwatch-kinesis.arn
  log_group_name  = "${var.namespace}-windows-eventlogs"
  filter_pattern  = "\"*\""
  destination_arn = aws_kinesis_stream.kinesis-logs-stream.arn
  distribution    = "Random"
}
