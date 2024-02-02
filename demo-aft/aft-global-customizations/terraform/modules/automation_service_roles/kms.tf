# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

resource "aws_iam_role" "kms_remediation_service_role" {
  name                  = "AutoRemediationServiceRoleForKMS"
  description           = "Performs AutoRemediation of KMS Keys Security Findings using a Lambda function triggered by EventBridge"
  path                  = "/aft/"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::*:role/aft/AutoRemediateLambdaRoleForServiceKMS"
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
    name = "AutoRemediationServiceRoleForKMS"

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
          Effect = "Allow"
          Action = [
            "kms:CancelKeyDeletion",
            "kms:DescribeKey",
            "kms:EnableKeyRotation",
            "kms:GetKeyRotationStatus"
          ]
          Resource = "arn:aws:kms:::*"
        }
      ]
    })
  }

  tags = {
    Name = "AutoRemediationServiceRoleForKMS"
  }
}

resource "aws_iam_role_policy_attachment" "kms_automation_service_policy_managed" {
  role       = aws_iam_role.kms_remediation_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMAutomationRole"
}
