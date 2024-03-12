# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_region" "current" {}

resource "aws_securityhub_organization_configuration" "this" {
  auto_enable = true
}

resource "aws_securityhub_standards_subscription" "aws_best_practices" {
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/aws-foundational-security-best-practices/v/1.0.0"
  depends_on    = [aws_securityhub_organization_configuration.this]
}

resource "aws_securityhub_standards_subscription" "cis_1_2_0" {
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
  depends_on    = [aws_securityhub_organization_configuration.this]
}

# resource "aws_securityhub_standards_subscription" "cis_1_4_0" {
#   standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.4.0"
#   depends_on    = [aws_securityhub_organization_configuration.this]
# }

resource "aws_securityhub_standards_subscription" "pci_3_2_1" {
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/pci-dss/v/3.2.1"
  depends_on    = [aws_securityhub_organization_configuration.this]
}

resource "aws_securityhub_standards_subscription" "nist_800_53_5" {
  standards_arn = "arn:aws:securityhub:${data.aws_region.current.name}::standards/nist-800-53/v/5.0.0"
  depends_on    = [aws_securityhub_organization_configuration.this]
}
