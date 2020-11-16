resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.namespace}_${var.component}_auto_dns"
  retention_in_days = 7

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/_auto_dns"
    )
  )
}

resource "aws_cloudwatch_event_rule" "this" {
  name_prefix = "${var.namespace}_${var.component}_auto_dns_"
  description = "Triggers the Auto Update DNS Lambda function when an EC2 instance is launched or terminated"

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
      "Name", "${var.namespace}/${var.component}/_auto_dns"
    )
  )
}

resource "aws_cloudwatch_event_target" "this" {
  rule = aws_cloudwatch_event_rule.this.name
  arn  = aws_lambda_function.this.arn

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

resource "aws_lambda_function" "this" {
  filename         = "${path.module}/lambda.zip"
  source_code_hash = filebase64sha256(data.archive_file.this.output_path)
  function_name    = "${var.namespace}_${var.component}_auto_dns"
  handler          = "lambda.lambda_handler"
  role             = aws_iam_role.this.arn
  description      = "Updates Route53 Private Zone DNS entries based on EC2 or AutoScaling Launch events"
  runtime          = "python3.7"
  timeout          = 30

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.component}_auto_dns"
    )
  )
}

resource "aws_lambda_permission" "this" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
