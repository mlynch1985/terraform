# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_iam_role" "s3_remediation_service_role" {
  name                  = "AutoRemediationServiceRoleForS3"
  description           = "Performs AutoRemediation of S3 Bucket and Object Security Findings using a Lambda function triggered by EventBridge"
  path                  = "/aft/"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::*:role/aft/AutoRemediateLambdaRoleForServiceS3"
        }
        Condition = {
          "StringEquals" = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id
          }
        }
      }
    ]
  })

  inline_policy {
    name = "AutoRemediationServiceRoleForS3"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect   = "Allow"
          Action   = "cloudwatch:PutMetricData"
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "arn:aws:logs:::*"
        },
        {
          Effect   = "Allow"
          Action   = ["s3:*"]
          Resource = "arn:aws:s3:::*"
        }
      ]
    })
  }

  tags = {
    Name = "AutoRemediationServiceRoleForS3"
  }
}

resource "aws_iam_role_policy_attachment" "s3_automation_service_policy_managed" {
  role       = aws_iam_role.s3_remediation_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}
