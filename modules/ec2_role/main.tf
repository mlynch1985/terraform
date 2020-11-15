resource "aws_iam_role" "this" {
  name_prefix           = "${var.namespace}_${var.app_role}_ec2_"
  force_detach_policies = true
  path                  = var.path
  description           = var.description
  max_session_duration  = var.max_session_duration

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            }
        }
    ]
}
EOF

  tags = var.default_tags
}

resource "aws_iam_role_policy_attachment" "ssm-policy" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch-policy" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "this" {
  name_prefix = "${var.namespace}_${var.app_role}_role_"
  role        = aws_iam_role.this.name
}

resource "aws_iam_role_policy" "s3" {
  name = "GrantS3"
  role = aws_iam_role.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.namespace}-${var.app_role}-*",
                "arn:aws:s3:::${var.namespace}-${var.app_role}-*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "parameter_store" {
  name = "GrantParameterStore"
  role = aws_iam_role.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssm:DescribeParameter*",
                "ssm:GetParameter*",
                "ssm:PutParameter*",
                "ssm:DeleteParameter*"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/${var.namespace}/${var.app_role}/*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "secrets_manager" {
  name = "GrantSecretsManager"
  role = aws_iam_role.this.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:ListSecrets",
                "secretsmanager:DescribeSecret",
                "secretsmanager:GetSecretValue"
            ],
            "Resource": "arn:aws:secretsmanager:*:*:secret:/${var.namespace}/${var.app_role}/*"
        }
    ]
}
EOF
}
