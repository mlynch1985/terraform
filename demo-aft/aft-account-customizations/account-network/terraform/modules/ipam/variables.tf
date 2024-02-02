# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

variable "pool_configurations" {
  type        = any
  default     = {}
  description = <<-EOF
  A multi-level, nested map describing nested IPAM pools. Can nest up to three levels with the top level being outside the `pool_configurations` in vars prefixed `top_`. If arugument descriptions are omitted, you can find them in the [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#argument-reference).

  - `ram_share_principals` = (optional, list(string)) of valid organization principals to create ram shares to.
  - `name`                 = (optional, string) name to give the pool, the key of your map in var.pool_configurations will be used if omitted.
  - `description`          = (optional, string) description to give the pool, the key of your map in var.pool_configurations will be used if omitted.
  - `cidr`                 = (optional, list(string)) list of CIDRs to provision into pool. Conflicts with `netmask_length`.
  - `netmask_length`       = (optional, number) netmask length to request provisioned into pool. Conflicts with `cidr`.

  - `locale`      = (optional, string) locale to set for pool.
  - `auto_import` = (optional, string)
  - `tags`        = (optional, map(string))
  - `allocation_default_netmask_length` = (optional, string)
  - `allocation_max_netmask_length`     = (optional, string)
  - `allocation_min_netmask_length`     = (optional, string)
  - `allocation_resource_tags`          = (optional, map(string))

  The following arguments are available but only relevant for public ips
  - `cidr_authorization_context` = (optional, map(string)) Details found in [official documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr_authorization_context).
  - `aws_service`                = (optional, string)
  - `publicly_advertisable`      = (optional, bool)

  - `sub_pools` = (nested repeats of pool_configuration object above)
EOF
}

variable "top_name" {
  description = "Name of top-level pool."
  type        = string
}

variable "top_cidr" {
  description = "Top-level CIDR blocks."
  type        = list(string)

  validation {
    condition = alltrue([
      for a in var.top_cidr : can(cidrhost(a, 0))
    ])
    error_message = "All elements must be valid IPv4 CIDR block addresses."
  }
}

variable "top_description" {
  description = "Description of top-level pool."
  type        = string
  default     = ""
}
