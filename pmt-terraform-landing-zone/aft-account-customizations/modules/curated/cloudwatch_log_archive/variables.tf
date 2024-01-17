# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "bucket_arn" {
  type        = string
  description = "ARN of the destination S3 bucket. CloudWatch Logs accross all regions are sent to this bucket."
}

variable "bucket_kms_key" {
  type        = string
  description = "ARN of KMS key in primary region used to encrypt objects in destination bucket."
}

variable "firehose_kms_key" {
  type        = string
  description = "ARN of KMS key used to enable Firehose SSE."
}
