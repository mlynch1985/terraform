resource "aws_iam_role" "vpc-flow-logs" {
    name = "vpc-flow-logs-role"
    force_detach_policies = true
    path = "/"
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

resource "aws_iam_role_policy" "vpc-flow-logs" {
    name = "GrantCloudwatchLogs"
    role = aws_iam_role.vpc-flow-logs.id
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantCloudwatchLogs",
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

resource "aws_cloudwatch_log_group" "vpc-flow-logs" {
    name = "vpc-flow-logs"
    retention_in_days = 7
}

resource "aws_flow_log" "vpc-flow-logs" {
    iam_role_arn = aws_iam_role.vpc-flow-logs.arn
    log_destination = aws_cloudwatch_log_group.vpc-flow-logs.arn
    traffic_type = "ALL"
    vpc_id = aws_vpc.vpc.id
}
