# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_organizations_organization" "current" {}

data "aws_iam_policy_document" "trust_policy" {
  statement {
    sid     = "AllowTrustedPrincipals"
    actions = ["sts:AssumeRole"]

    dynamic "principals" {
      for_each = var.principals

      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
  }

  statement {
    sid     = "EnforceIdentityPerimeter"
    effect  = "Deny"
    actions = ["sts:AssumeRole", "sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringNotEqualsIfExists"
      variable = "aws:PrincipalOrgID"
      values   = [data.aws_organizations_organization.current.id]
    }
    condition {
      test     = "BoolIfExists"
      variable = "aws:PrincipalIsAWSService"
      values   = ["false"]
    }
  }
}

resource "aws_iam_role" "this" {
  name                  = var.role_name
  assume_role_policy    = data.aws_iam_policy_document.trust_policy.json
  description           = var.role_description
  force_detach_policies = true
  max_session_duration  = var.max_session_duration
  path                  = var.path
}

resource "aws_iam_policy" "this" {
  name_prefix = var.role_name != null ? "${var.role_name}_" : null
  description = var.policy_description
  policy      = var.policy_document
  path        = var.path
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}
