data "aws_caller_identity" "this" {}

data "aws_iam_instance_profile" "this" {
  name = var.iam_instance_profile
}

resource "aws_kms_key" "this" {
  description = "${var.namespace}/${var.component}/EBS_CMK"
  policy      = data.aws_iam_policy_document.this.json

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.component}_EBS_CMK"
    )
  )
}

data "aws_iam_policy_document" "this" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"]
    }
  }
}

resource "aws_iam_role_policy" "this" {
  name = "GrantKMS"
  role = data.aws_iam_instance_profile.this.role_name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "${aws_kms_key.this.arn}"
        }
    ]
}
EOF
}
