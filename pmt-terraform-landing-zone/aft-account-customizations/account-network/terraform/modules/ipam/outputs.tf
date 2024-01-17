# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "operating_regions" {
  description = "List of all IPAM operating regions."
  value       = local.operating_regions
}

output "pool_names" {
  description = "List of all pool names."
  value       = concat(try(local.level_1_pool_names, []), try(local.level_2_pool_names, []), try(local.level_3_pool_names, []))
}

output "pool_level_0" {
  description = "Map of all pools at level 0."
  value       = module.level_zero.pool
}

output "pools_level_1" {
  description = "Map of all pools at level 1."
  value       = try({ for k, v in module.level_one : k => v.pool }, null)
}

output "pools_level_2" {
  description = "Map of all pools at level 2."
  value       = try({ for k, v in module.level_two : k => v.pool }, null)
}

output "pools_level_3" {
  description = "Map of all pools at level 3."
  value       = try({ for k, v in module.level_three : k => v.pool }, null)
}

output "ipam_info" {
  description = "If created, ouput the IPAM object information."
  value       = aws_vpc_ipam.this
}
