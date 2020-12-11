data "aws_caller_identity" "this" {}

data "aws_iam_instance_profile" "this" {
  name = var.iam_instance_profile.name
}

resource "aws_iam_service_linked_role" "this" {
  aws_service_name = "autoscaling.amazonaws.com"
  custom_suffix    = "${var.namespace}_${var.component}"
}

resource "time_sleep" "this" {
  depends_on      = [aws_iam_service_linked_role.this]
  create_duration = "5s"
}

resource "aws_kms_key" "this" {
  depends_on = [time_sleep.this]

  description = "${var.namespace}/${var.component}/EBS_CMK"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Id": "custom-policy-1",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Action": "kms:*",
      "Resource": "*",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
        ]
      }
    },
    {
      "Sid": "Allow service-linked role use of the CMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*",
      "Principal": {
        "AWS": [
          "${aws_iam_service_linked_role.this.arn}"
        ]
      }
    },
    {
      "Sid": "Allow attachment of persistent resources",
      "Effect": "Allow",
      "Action": [
        "kms:CreateGrant"
      ],
      "Resource": "*",
      "Principal": {
        "AWS": [
          "${aws_iam_service_linked_role.this.arn}"
        ]
      },
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": true
        }
      }
    }
  ]
}
EOF

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.component}_EBS_CMK"
    )
  )
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
