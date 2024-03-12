# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "key_name" {
  description = "Please specify a valid KMS Key Name to be used for the Alias"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_/]{1,250}$", var.key_name))
    error_message = "Please specify a valid KMS Key Name (^[a-zA-Z0-9-_/]{1,250}$) https://docs.aws.amazon.com/kms/latest/APIReference/API_CreateAlias.html#KMS-CreateAlias-request-AliasName"
  }
}

variable "key_policy" {
  type        = string
  description = "JSON IAM policy document"
}

variable "primary_key_arn" {
  type        = string
  description = "The ARN of the multi-Region primary key to replicate. The primary key must be in a different AWS Region of the same AWS Partition. You can create only one replica of a given primary key in each AWS Region."
}
