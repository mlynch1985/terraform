## Define the Base Role
resource "aws_iam_role" "role-ec2-windowsjump" {
  name                  = "${var.namespace}-role-ec2-windowsjump"
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
resource "aws_iam_role_policy_attachment" "attach-ec2-windowsjump-cloudwatch" {
  role       = aws_iam_role.role-ec2-windowsjump.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

## Attach SSMManagedInstanceCore Policy
resource "aws_iam_role_policy_attachment" "attach-ec2-windowsjump-ssm" {
  role       = aws_iam_role.role-ec2-windowsjump.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Grant EC2 API Access to query for instance tags
resource "aws_iam_role_policy" "inline-ec2-windowsjump-describetags" {
  name        = "GrantEC2DescribeTags"
	role = aws_iam_role.role-ec2-windowsjump.name

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
resource "aws_iam_role_policy" "inline-ec2-windowsjump-s3copyobject" {
  name        = "GrantS3CopyObject"
	role = aws_iam_role.role-ec2-windowsjump.name

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

## Create EC2 Instance Profile
resource "aws_iam_instance_profile" "ec2-windowsjump-instance-profile" {
  name = "${var.namespace}-ec2-windowsjump"
  role = aws_iam_role.role-ec2-windowsjump.name
}
