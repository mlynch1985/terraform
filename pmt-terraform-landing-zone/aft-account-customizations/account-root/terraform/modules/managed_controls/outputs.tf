# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

output "ous_id_to_arn_map" {
  value       = local.ous_id_to_arn_map
  description = "Map from OU id to OU arn for the whole organization"
}
