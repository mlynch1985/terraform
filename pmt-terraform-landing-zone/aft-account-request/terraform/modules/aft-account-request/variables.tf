# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "account-request-table" {
  type        = string
  description = "name of account-request-table"
  default     = "aft-request"
}

variable "account-request-table-hash" {
  type        = string
  description = "name of account-request-table hash key"
  default     = "id"
}

variable "control_tower_parameters" {
  type = object({
    AccountEmail              = string
    AccountName               = string
    ManagedOrganizationalUnit = string
    SSOUserEmail              = string
    SSOUserFirstName          = string
    SSOUserLastName           = string
  })
}

variable "change_management_parameters" {
  type = object({
    change_requested_by = string
    change_reason       = string
  })
}

variable "account_tags" {
  type        = map(any)
  description = "map of account-level tags"
  default     = {}
}

variable "custom_fields" {
  type        = map(any)
  description = "map of custom fields defined by the customer"
  default     = {}
}

variable "account_customizations_name" {
  type        = string
  default     = ""
  description = "The name of the account customizations to apply"
}
