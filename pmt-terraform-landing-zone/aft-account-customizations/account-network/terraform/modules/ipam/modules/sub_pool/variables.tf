# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "pool_config" {
  description = "Configuration of the Pool you want to deploy. All aws_vpc_ipam_pool arguments are available as well as ram_share_principals list and sub_pools map (up to 3 levels)."
  type = object({
    cidr                 = list(string)
    locale               = optional(string)
    name                 = string
    netmask_length       = optional(number)
    ram_share_principals = optional(list(string))
    sub_pools            = optional(any)
  })
}

variable "implied_locale" {
  type        = string
  description = "Locale is implied from a parent pool even if another is specified. Its not possible to set child pools to different locales."
  default     = null
}

variable "implied_name" {
  type        = string
  description = "Name is implied from the pool tree name <parent>/<child> unless specified on the pool_config."
  default     = null
}

variable "ipam_scope_id" {
  description = "IPAM Scope ID to attach the pool to."
  type        = string
}

variable "source_ipam_pool_id" {
  description = "IPAM parent pool ID to attach the pool to."
  type        = string
  default     = null
}
