resource "aws_iam_role" "role" {
    name_prefix = "${var.role_name}_"
    path = "/${var.default_tags.namespace}/"

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

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_${var.role_name}"
        )
    )
}

resource "aws_iam_role_policy_attachment" "ssm" {
    role = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
    role = aws_iam_role.role.name
    policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy" "s3" {
    name_prefix = "s3_"
    role = aws_iam_role.role.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${replace(var.default_tags.namespace, "_", "-")}*",
                "arn:aws:s3:::${replace(var.default_tags.namespace, "_", "-")}*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "parameter_store" {
    name_prefix = "parameter_store_"
    role = aws_iam_role.role.id

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
            "Resource": "arn:aws:ssm:${var.region}:${var.account_id}:parameter/${replace(var.default_tags.namespace, "_", "/")}/*"
        }
    ]
}
EOF
}

resource "aws_iam_instance_profile" "profile" {
    name_prefix = "${var.role_name}_"
    path = "/${var.default_tags.namespace}/"
    role = aws_iam_role.role.name
}
