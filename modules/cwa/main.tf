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

resource "aws_cloudwatch_log_group" "ec2_state_alarm" {
  name              = "/aws/lambda/${var.namespace}_${var.app_role}_ec2_state_alarm"
  retention_in_days = 7

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_ec2_state_alarm"
    )
  )
}

resource "aws_cloudwatch_event_rule" "ec2_state_alarm" {
  name_prefix = "${var.namespace}_${var.app_role}_ec2_state_alarm_"
  description = "Triggers the EC2 State Changed Alarm Lambda function when an EC2 instance is launched or terminated"

  event_pattern = <<EOF
{
  "source": ["aws.autoscaling"],
  "detail-type": ["EC2 Instance Launch Successful", "EC2 Instance Terminate Successful"],
  "detail": {
    "AutoScalingGroupName": ["${var.auto_scaling_group_name}"]
  }
}
EOF

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_ec2_state_alarm"
    )
  )
}

resource "aws_cloudwatch_event_target" "ec2_state_alarm" {
  rule = aws_cloudwatch_event_rule.ec2_state_alarm.name
  arn  = aws_lambda_function.ec2_state_alarm.arn

  input_transformer {
    input_paths = {
      instance                = "$.detail.EC2InstanceId",
      detail_type             = "$.detail-type",
      auto_scaling_group_name = "$.detail.AutoScalingGroupName"
    }
    input_template = <<EOF
{
    "instance_id": <instance>,
    "detail_type": <detail_type>,
    "auto_scaling_group_name": <auto_scaling_group_name>
}
EOF
  }
}

resource "aws_lambda_function" "ec2_state_alarm" {
  filename      = "${path.module}/lambda.zip"
  function_name = "${var.namespace}_${var.app_role}_ec2_state_alarm"
  handler       = "lambda.lambda_handler"
  role          = aws_iam_role.this.arn
  description   = "Creates Cloudwatch Metric Alarms when a new EC2 instance is launched or deletes them when terminated"
  runtime       = "python3.7"
  timeout       = 30

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_ec2_state_alarm"
    )
  )
}

resource "aws_lambda_permission" "ec2_state_alarm" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_state_alarm.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_state_alarm.arn
}
