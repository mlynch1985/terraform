# © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

data "aws_ssm_parameter" "ipam_root_cidr" {
  name = "/aft/account-request/custom-fields/ipam_root_cidr"
}

locals {
  # Allows us to use the SSM Parameter in a for_each loop
  ipam_root_cidr = nonsensitive(data.aws_ssm_parameter.ipam_root_cidr.value)

  # Calculate Regional IPAM Pool sizes dynamically
  region1_pool = cidrsubnet(local.ipam_root_cidr, 2, 0) # Home Region
  region2_pool = cidrsubnet(local.ipam_root_cidr, 2, 1) # Backup Region
  region3_pool = cidrsubnet(local.ipam_root_cidr, 2, 2) # Tertiary Region
  region4_pool = cidrsubnet(local.ipam_root_cidr, 2, 3) # Reserved 1
}

module "ipam" {
  source = "./modules/ipam"

  top_name = "ipam_root"
  top_cidr = [local.ipam_root_cidr]

  pool_configurations = {
    (local.region1_name) = {
      cidr   = [local.region1_pool]
      name   = local.region1_name
      locale = local.region1_name

      sub_pools = {
        workloads = {
          name                 = "workloads"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1), 0)]
          ram_share_principals = [local.workloads_arn]
        }

        infrastructure = {
          name                 = "infrastructure"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2), 1)]
          ram_share_principals = [local.infrastructure_arn]
        }

        sandbox = {
          name                 = "sandbox"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2, 3), 2)]
          ram_share_principals = [local.sandbox_arn]
        }

        security = {
          name                 = "security"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2, 3, 5, 5, 5, 5), 3)]
          ram_share_principals = [local.security_arn]
        }

        deployments = {
          name                 = "deployments"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2, 3, 5, 5, 5, 5), 4)]
          ram_share_principals = [local.deployments_arn]
        }

        exceptions = {
          name                 = "exceptions"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2, 3, 5, 5, 5, 5), 5)]
          ram_share_principals = [local.exceptions_arn]
        }

        policy_staging = {
          name                 = "policy_staging"
          cidr                 = [element(cidrsubnets(local.region1_pool, 1, 2, 3, 5, 5, 5, 5), 6)]
          ram_share_principals = [local.policy_staging_arn]
        }
      }
    }

    (local.region2_name) = {
      cidr   = [local.region2_pool]
      name   = local.region2_name
      locale = local.region2_name

      sub_pools = {
        workloads = {
          name                 = "workloads"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1), 0)]
          ram_share_principals = [local.workloads_arn]
        }

        infrastructure = {
          name                 = "infrastructure"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2), 1)]
          ram_share_principals = [local.infrastructure_arn]
        }

        sandbox = {
          name                 = "sandbox"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2, 3), 2)]
          ram_share_principals = [local.sandbox_arn]
        }

        security = {
          name                 = "security"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2, 3, 5, 5, 5, 5), 3)]
          ram_share_principals = [local.security_arn]
        }

        deployments = {
          name                 = "deployments"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2, 3, 5, 5, 5, 5), 4)]
          ram_share_principals = [local.deployments_arn]
        }

        exceptions = {
          name                 = "exceptions"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2, 3, 5, 5, 5, 5), 5)]
          ram_share_principals = [local.exceptions_arn]
        }

        policy_staging = {
          name                 = "policy_staging"
          cidr                 = [element(cidrsubnets(local.region2_pool, 1, 2, 3, 5, 5, 5, 5), 6)]
          ram_share_principals = [local.policy_staging_arn]
        }
      }
    }
  }
}
