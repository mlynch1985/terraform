# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "bucket_arn" {
  type        = string
  description = "The ARN of the destination S3 bucket"

  validation {
    condition     = can(regex("^arn:.*", var.bucket_arn))
    error_message = "Please specify a valid S3 bucket ARN (^[a-zA-Z0-9-_/]{1,250}$) https://docs.aws.amazon.com/firehose/latest/APIReference/API_ExtendedS3DestinationConfiguration.html#Firehose-Type-ExtendedS3DestinationConfiguration-BucketARN"
  }
}

variable "bucket_kms_key" {
  type        = string
  description = "ARN of KMS key in primary region used to encrypt objects in destination bucket."
}

variable "name" {
  type        = string
  description = "A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
}

variable "role_arn" {
  type        = string
  description = "The arn of the role the stream assumes."
}

variable "firehose_kms_key" {
  type        = string
  description = "ARN of KMS key used to enable Firehose SSE."
}
