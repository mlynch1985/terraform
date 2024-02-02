# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_organizations_resource_tags" "current" {
  resource_id = data.aws_caller_identity.current.account_id
  provider    = aws.ct-management
}

resource "aws_securityhub_account" "this" {
  count = data.aws_organizations_resource_tags.current.tags["Name"] != "Audit" ? 1 : 0 # Only enable SecurityHub if not already enabled
}

resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  count         = var.enable_aws_best_practices ? 1 : 0
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "cis_1_2_0" {
  count         = var.enable_cis_1_2_0 ? 1 : 0
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "cis_1_4_0" {
  count         = var.enable_cis_1_4_0 ? 1 : 0
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "pci_3_2_1" {
  count         = var.enable_pci_3_2_1 ? 1 : 0
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"
  depends_on    = [aws_securityhub_account.this]
}

resource "aws_securityhub_standards_subscription" "nist_800_53_5" {
  count         = var.enable_nist_800_53_5 ? 1 : 0
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/nist-800-53/v/5.0.0"
  depends_on    = [aws_securityhub_account.this]
}
