## Create an Alias for the KMS Key
resource "aws_kms_alias" "kms-alias-kinesis" {
  name          = "alias/${var.namespace}-kms-kinesis"
  target_key_id = aws_kms_key.kms-key-kinesis.id
}

## Define our Customer Managed KMS Key
resource "aws_kms_key" "kms-key-kinesis" {
  description             = "kms-kinesis"
  deletion_window_in_days = 7
  tags = {
    Name        = "${var.namespace}-kms-kinesis"
    Environment = var.environment
    Namespace   = var.namespace
  }
  policy = <<EOF
{
    "Id": "${var.namespace}-kms-kinesis",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow access for Key Administrators",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin"
            },
            "Action": [
                "kms:Create*",
                "kms:Describe*",
                "kms:Enable*",
                "kms:List*",
                "kms:Put*",
                "kms:Update*",
                "kms:Revoke*",
                "kms:Disable*",
                "kms:Get*",
                "kms:Delete*",
                "kms:TagResource",
                "kms:UntagResource",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${var.region}.amazonaws.com",
                "AWS": "${aws_iam_role.role-cloudwatch-kinesis.arn}"
            },
            "Action": [
                "kms:Decrypt",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        },
        {
            "Sid": "Allow attachment of persistent resources",
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.${var.region}.amazonaws.com",
                "AWS": "${aws_iam_role.role-cloudwatch-kinesis.arn}"
            },
            "Action": [
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:RevokeGrant"
            ],
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        }
    ]
}
EOF
}