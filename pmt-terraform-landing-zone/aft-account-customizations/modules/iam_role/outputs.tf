# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "name" {
  value       = aws_iam_role.this.name
  description = "The name of the IAM role created"
}

output "id" {
  value       = aws_iam_role.this.unique_id
  description = "The stable and unique string identifying the role"
}

output "arn" {
  value       = aws_iam_role.this.arn
  description = "The Amazon Resource Name (ARN) specifying the role"
}
