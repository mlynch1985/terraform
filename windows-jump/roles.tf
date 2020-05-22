## Define the Base Role
resource "aws_iam_role" "windowsjump" {
  name                  = "${var.namespace}_ec2_windowsjump"
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
      "Effect": "Allow"
    }
  ]
}
EOF
}

## Attach CloudwatchAgentServer Policy
resource "aws_iam_role_policy_attachment" "windowsjump_cloudwatch" {
  role       = aws_iam_role.windowsjump.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

## Attach SSMManagedInstanceCore Policy
resource "aws_iam_role_policy_attachment" "windowsjump_ssm" {
  role       = aws_iam_role.windowsjump.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Grant EC2 API Access to query for instance tags
resource "aws_iam_role_policy" "windowsjump_describetags" {
  name = "GrantEC2DescribeTags"
  role = aws_iam_role.windowsjump.name

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
resource "aws_iam_role_policy" "windowsjump_copyobject" {
  name = "GrantS3CopyObject"
  role = aws_iam_role.windowsjump.name

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

## Grant SecretsManager access to obtain Admin Passwords
resource "aws_iam_role_policy" "windowsjump_getsecretvalue" {
  name = "GrantGetSecretValue"
  role = aws_iam_role.windowsjump.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "GrantGetSecretValue",
          "Effect": "Allow",
          "Action": [
            "secretsmanager:GetSecretValue",
            "secretsmanager:DescribeSecret"
          ],
          "Resource": "${data.aws_secretsmanager_secret.windowsjump.arn}"
        },
        {
          "Sid": "GrantKMSDecrypt",
          "Effect": "Allow",
          "Action": [
            "kms:Decrypt"
          ],
          "Resource": "${aws_kms_key.windowsjump.arn}"
        }
    ]
}
EOF
}

## Create EC2 Instance Profile
resource "aws_iam_instance_profile" "windowsjump" {
  name = "${var.namespace}_ec2_windowsjump"
  role = aws_iam_role.windowsjump.name
}
