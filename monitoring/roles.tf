## Define the Base Role
resource "aws_iam_role" "elasticsearch" {
  name                  = "${var.namespace}_ec2_elasticsearch"
  force_detach_policies = true
  path                  = "/app/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

## Attach CloudwatchAgentServer Policy
resource "aws_iam_role_policy_attachment" "elasticsearch_cloudwatch" {
  role       = aws_iam_role.elasticsearch.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

## Attach SSMManagedInstanceCore Policy
resource "aws_iam_role_policy_attachment" "elasticsearch_ssm" {
  role       = aws_iam_role.elasticsearch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Attach AmazonDynamoDBFullAccess Policy
resource "aws_iam_role_policy_attachment" "elasticsearch_dynamodb" {
  role       = aws_iam_role.elasticsearch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

## Attach AmazonKinesisFullAccess Policy
resource "aws_iam_role_policy_attachment" "elasticsearch_kinesis" {
  role       = aws_iam_role.elasticsearch.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

## Grant EC2 API Access to query for instance details
resource "aws_iam_role_policy" "elasticsearch_describeinstances" {
  name = "GrantEC2DescribeIntances"
  role = aws_iam_role.elasticsearch.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantEC2DescribeInstances",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeInstances"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

## Grant EC2 API Access to query for instance tags
resource "aws_iam_role_policy" "elasticsearch_describetags" {
  name = "GrantEC2DescribeTags"
  role = aws_iam_role.elasticsearch.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantEC2DescribeTags",
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

## Grant S3 API Access to download CloudwatchAgent Config file
resource "aws_iam_role_policy" "elasticsearch_copyobject" {
  name = "GrantS3CopyObject"
  role = aws_iam_role.elasticsearch.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
			"Sid": "GrantS3CopyObject",
			"Effect": "Allow",
			"Action": [
				"s3:Get*",
				"s3:List*",
                "s3:CopyObject",
                "s3:GetBucketLocation"
			],
      "Resource": "*"
    }
  ]
}
EOF
}

## Grant Cloudwatch API Access to read Metrics
resource "aws_iam_role_policy" "elasticsearch_cloudwatch" {
  name = "GrantCloudwatchReadOnly"
  role = aws_iam_role.elasticsearch.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantCloudwatchReadOnly",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:List*",
        "cloudwatch:Describe*",
        "cloudwatch:Get*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}


## Create EC2 Instance Profile
resource "aws_iam_instance_profile" "elasticsearch" {
  name = "${var.namespace}_ec2_elasticsearch"
  role = aws_iam_role.elasticsearch.name
}


## Define Cloudwatch to Kinesis Subscription Filter Role
resource "aws_iam_role" "subscription_filter_windows_eventlogs" {
  name                  = "${var.namespace}_cw_windows_eventlogs"
  force_detach_policies = true
  path                  = "/app/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "logs.${var.region}.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

## Grant Cloudwatch Logs API Access to write Logs to Kinesis
resource "aws_iam_role_policy" "subscription_filter_windows_eventlogs" {
  name = "GrantKinesisPutRecords"
  role = aws_iam_role.subscription_filter_windows_eventlogs.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GrantKinesisReadOnly",
            "Effect": "Allow",
            "Action": [
                "kinesis:ListStreams",
                "kinesis:PutRecord",
                "kinesis:PutRecords",
                "kinesis:DescribeStream"
            ],
            "Resource": "${aws_kinesis_stream.windows_eventlogs.arn}"
        }
    ]
}
EOF
}
