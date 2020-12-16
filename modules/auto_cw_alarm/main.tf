resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.namespace}/${var.component}/cw_alarms"
  retention_in_days = 7

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cw_alarms"
    )
  )
}

resource "aws_lambda_function" "this" {
  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256(data.archive_file.this.output_path)
  function_name    = "${var.namespace}_${var.component}_cw_alarms"
  handler          = "lambda.lambda_handler"
  role             = aws_iam_role.this.arn
  description      = "Creates Cloudwatch Metric Alarms when a new EC2 instance is launched or deletes them when terminated"
  runtime          = "python3.7"
  timeout          = 30

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cw_alarms"
    )
  )
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}

resource "aws_cloudwatch_event_rule" "this" {
  name_prefix = "${var.namespace}_${var.component}_cw_alarms_"
  description = "Triggers CloudWatch Alarm Lambda function for EC2 AutoScaling Launch/Terminate events."

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
      "Name", "${var.namespace}/${var.component}/cw_alarms"
    )
  )
}

resource "aws_sns_topic" "this" {
  name_prefix  = "${var.namespace}_${var.component}_cw_alarms_"
  display_name = "${var.namespace}_${var.component}_cw_alarms"

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cw_alarms"
    )
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]
    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "cloudwatch.amazonaws.com"
      ]
    }
    resources = [aws_sns_topic.this.arn]
  }
}

resource "aws_sns_topic_policy" "this" {
  arn    = aws_sns_topic.this.arn
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = aws_lambda_function.this.arn

  input_transformer {
    input_paths = {
      instance_id             = "$.detail.EC2InstanceId",
      detail_type             = "$.detail-type",
      auto_scaling_group_name = "$.detail.AutoScalingGroupName"
    }
    input_template = <<EOF
{
    "instance_id": <instance_id>,
    "detail_type": <detail_type>,
    "auto_scaling_group_name": <auto_scaling_group_name>
}
EOF
  }
}

resource "aws_cloudwatch_event_target" "sns" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = aws_sns_topic.this.arn

  input_transformer {
    input_paths = {
      instance_id             = "$.detail.EC2InstanceId",
      detail_type             = "$.detail-type",
      auto_scaling_group_name = "$.detail.AutoScalingGroupName"
    }
    input_template = <<EOF
{
    "instance_id": <instance_id>,
    "detail_type": <detail_type>,
    "auto_scaling_group_name": <auto_scaling_group_name>
}
EOF
  }
}
