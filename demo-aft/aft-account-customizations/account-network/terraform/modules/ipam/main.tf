# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  # Contains list of Region pools
  level_1_pool_names = [for region, pool in var.pool_configurations : region]

  # Contains list of Parent OU pools
  level_2_pool_names = compact(flatten([for region, pool in var.pool_configurations : try([for ou_name, pool in pool.sub_pools : "${region}/${ou_name}"], null)]))

  # Create list of level 2 pools that have a nested child pool
  level_2_pool_names_with_3rd_level = [for pool in local.level_2_pool_names : pool if try(var.pool_configurations[split("/", pool)[0]].sub_pools[split("/", pool)[1]].sub_pools, null) != null]

  # Contains list of Child OU pools
  level_3_pool_names = flatten([for pool in local.level_2_pool_names_with_3rd_level : [for sub_pool in keys(var.pool_configurations[split("/", pool)[0]].sub_pools[split("/", pool)[1]].sub_pools) : "${pool}/${sub_pool}"]])

  # find all unique values where key = locale
  all_locales = distinct(compact(flatten(concat([for k, v in var.pool_configurations : try(v.locale, null)],
    [for k, v in var.pool_configurations : try([for k2, v2 in v.sub_pools : try(v2.locale, null)], null)],
    [for k, v in local.level_3_pool_names : try(var.pool_configurations[split("/", v)[0]].sub_pools[split("/", v)[1]].sub_pools[split("/", v)[2]].locale, null)]
  ))))

  # its possible to create pools in all regions except the primary, but we must pass the primary region
  # to aws_vpc_ipam.operating_regions.region_name
  operating_regions = distinct(concat(local.all_locales, [data.aws_region.current.name]))
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "this" {
  cascade = true

  dynamic "operating_regions" {
    for_each = toset(local.operating_regions)
    content {
      region_name = operating_regions.key
    }
  }

  tags = {
    Name = var.top_name
  }
}

module "level_zero" {
  source = "./modules/sub_pool"

  ipam_scope_id = aws_vpc_ipam.this.private_default_scope_id

  pool_config = {
    cidr = var.top_cidr
    name = var.top_name
  }
}

module "level_one" {
  source   = "./modules/sub_pool"
  for_each = var.pool_configurations

  ipam_scope_id       = aws_vpc_ipam.this.private_default_scope_id
  source_ipam_pool_id = module.level_zero.pool.id
  pool_config         = var.pool_configurations[each.key]
}

module "level_two" {
  source   = "./modules/sub_pool"
  for_each = toset(local.level_2_pool_names)

  ipam_scope_id       = aws_vpc_ipam.this.private_default_scope_id
  source_ipam_pool_id = module.level_one[split("/", each.key)[0]].pool.id
  pool_config         = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]]
  implied_locale      = module.level_one[split("/", each.key)[0]].pool.locale
}

module "level_three" {
  source   = "./modules/sub_pool"
  for_each = toset(local.level_3_pool_names)

  ipam_scope_id       = aws_vpc_ipam.this.private_default_scope_id
  source_ipam_pool_id = module.level_two[join("/", [split("/", each.key)[0], split("/", each.key)[1]])].pool.id
  pool_config         = var.pool_configurations[split("/", each.key)[0]].sub_pools[split("/", each.key)[1]].sub_pools[split("/", each.key)[2]]
  implied_locale      = module.level_two[join("/", [split("/", each.key)[0], split("/", each.key)[1]])].pool.locale
}
