## Define the Base Role
resource "aws_iam_role" "role-cloudwatch-kinesis" {
  name                  = "${var.namespace}-role-cloudwatch-kinesis"
  force_detach_policies = true
  path                  = "/app/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.${var.region}.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

## Grant API Access to write to Kinesis Stream and Encrypt with KMS CMK
resource "aws_iam_role_policy" "inline-cloudwatch-kinesis" {
  name = "GrantKinesisPutRecords"
  role = aws_iam_role.role-cloudwatch-kinesis.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GrantKinesisPutRecords",
      "Effect": "Allow",
      "Action": [
        "kinesis:PutRecord",
        "kinesis:PutRecords"
      ],
      "Resource": "${aws_kinesis_stream.kinesis-logs-stream.arn}"
    },
    {
      "Sid": "AllowPassRole",
      "Effect": "Allow",
      "Action": "iam:PrassRole",
      "Resource": "${aws_iam_role.role-cloudwatch-kinesis.arn}"
    },
    {
      "Sid": "GrantKMSGenerateDataKey",
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey"
      ],
      "Resource": "${aws_kms_key.kms-key-kinesis.arn}"
    }
  ]
}
EOF
}
