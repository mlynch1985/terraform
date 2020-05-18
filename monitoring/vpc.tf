## Create IAM Role
resource "aws_iam_role" "vpc-flow-logs-role" {
  name                  = "${var.namespace}-role-vpc-flowlogs"
  force_detach_policies = true
  path                  = "/app/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

## Create Inline Policy Granting Access to Cloudwatch Logs
resource "aws_iam_role_policy" "vpc-flow-logs-policy" {
  name = "GrantCloudwatchLogs"
  role = aws_iam_role.vpc-flow-logs-role.id

  policy = <<EOF
{
  "Sid": "GrantCloudwatchLogs",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

## Create Cloudwatch Log Group to hold VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc-flow-logs-group" {
  name              = "${var.namespace}-vpc-flow-logs"
  retention_in_days = 7
  tags = {
    Name        = "${var.namespace}-vpc-flow-logs"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define VPC Flow Logs to be pushed to Cloudwatch
resource "aws_flow_log" "vpc-flow-logs" {
  iam_role_arn    = aws_iam_role.vpc-flow-logs-role.arn
  log_destination = aws_cloudwatch_log_group.vpc-flow-logs-group.arn
  traffic_type    = "ALL"
  vpc_id          = data.aws_vpc.vpc.id
}
