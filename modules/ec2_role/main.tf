resource "aws_iam_role" "this" {
  name_prefix           = "${var.namespace}_${var.name}_role"
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

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.name}_role"
    )
  )
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
  name_prefix = "${var.namespace}_${var.name}_role"
  role        = aws_iam_role.this.name
}
