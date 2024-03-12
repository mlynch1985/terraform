# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "kms_key_arn" {
  description = "The AWS ARN for the account wide KMS Customer Managed Key"
  value       = aws_kms_key.this.arn
}
