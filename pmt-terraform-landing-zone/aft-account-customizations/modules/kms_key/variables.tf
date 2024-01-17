# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "enable_multi_region" {
  description = "Please specify either \"true\" or \"false\" to enable multi-region support"
  type        = bool
  default     = false
}

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
