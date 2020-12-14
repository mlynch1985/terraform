resource "aws_iam_role" "this" {
  name_prefix           = "${var.namespace}_${var.component}_cw_alarm_"
  force_detach_policies = true
  path                  = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            }
        }
    ]
}
EOF

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/cw_alarm"
    )
  )
}

resource "aws_iam_role_policy" "cloudwatch_logs" {
  name = "GrantCloudwatchLogs"
  role = aws_iam_role.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch_alarms" {
  name = "GrantCloudwatchAlarms"
  role = aws_iam_role.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:DescribeAlarms",
                "cloudwatch:PutMetricAlarm",
                "cloudwatch:DeleteAlarms",
                "ec2:DescribeInstances"
            ],
            "Resource": ["*"]
        }
    ]
}
EOF
}
