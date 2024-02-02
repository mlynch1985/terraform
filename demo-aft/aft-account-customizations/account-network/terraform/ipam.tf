# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

locals {
  # Define top level IPAM Cidr for entire AWS environment
  ipam_root_cidr = "10.0.0.0/8"

  # Split Root CIDR into 4 /10 regional cidrs containing ~4 milion IP addresses
  region1_pool = cidrsubnet(local.ipam_root_cidr, 2, 0) # 10.0.0.0/10
  region2_pool = cidrsubnet(local.ipam_root_cidr, 2, 1) # 10.64.0.0/10
  region3_pool = cidrsubnet(local.ipam_root_cidr, 2, 2) # 10.128.0.0/10
  region4_pool = cidrsubnet(local.ipam_root_cidr, 2, 3) # 10.192.0.0/10 Reserved for later use

  # Below is the expected IPAM Pool for each OU based on a 10.0.0.0/8 IPAM and 10.0.0.0/10 Regional Pool
  ## Example for Region 1 (10.0.0.0/10)
  ## OU               CIDR          Offset    Index
  ## Workloads        10.0.0.0/12    N/A       N/A
  #### Dev            10.0.0.0/14     4         0
  #### Test           10.4.0.0/14     4         1
  #### Prod           10.8.0.0/14     4         2
  #### Reserved       10.12.0.0/14    4         3
  ## Infrastructure   10.16.0.0/12   N/A       N/A
  #### Dev            10.16.0.0/14    4         4
  #### Test           10.20.0.0/14    4         5
  #### Prod           10.24.0.0/14    4         6
  #### Reserved       10.28.0.0/14    4         7
  ## Sandbox          10.32.0.0/12    2         8
  ## Exception        10.48.0.0/16    6         9
  ## Security         10.49.0.0/16    6        10
  ## Deployments      10.50.0.0/16    6        11
  ## Policy Staging   10.51.0.0/16    6        12
  ## Reserved         10.52.0.0/14    4        13
  ## Reserved         10.56.0.0/13    3        14
  region1_cidrs = cidrsubnets(local.region1_pool, 4, 4, 4, 4, 4, 4, 4, 4, 2, 6, 6, 6, 6, 4, 3)
  region2_cidrs = cidrsubnets(local.region2_pool, 4, 4, 4, 4, 4, 4, 4, 4, 2, 6, 6, 6, 6, 4, 3)
  region3_cidrs = cidrsubnets(local.region3_pool, 4, 4, 4, 4, 4, 4, 4, 4, 2, 6, 6, 6, 6, 4, 3)
  region4_cidrs = cidrsubnets(local.region4_pool, 4, 4, 4, 4, 4, 4, 4, 4, 2, 6, 6, 6, 6, 4, 3)
}

module "dev_ipam" {
  source = "./modules/ipam"

  top_name = "dev_ipam"
  top_cidr = [local.ipam_root_cidr]

  pool_configurations = {
    (local.global_vars.region1) = {
      cidr   = [local.region1_pool]
      name   = local.global_vars.region1
      locale = local.global_vars.region1

      sub_pools = {
        Workloads_Dev = {
          name                 = "Workloads_Dev"
          cidr                 = [element(local.region1_cidrs, 0)]
          ram_share_principals = [local.all_ous["Workloads/Dev"].arn]
        }
        Workloads_Test = {
          name                 = "Workloads_Test"
          cidr                 = [element(local.region1_cidrs, 1)]
          ram_share_principals = [local.all_ous["Workloads/Test"].arn]
        }
        Workloads_Prod = {
          name                 = "Workloads_Prod"
          cidr                 = [element(local.region1_cidrs, 2)]
          ram_share_principals = [local.all_ous["Workloads/Prod"].arn]
        }
        # Workloads_Reserved = {
        #   name                 = "Workloads_Reserved"
        #   cidr                 = [element(local.region1_cidrs, 3)]
        #   ram_share_principals = [local.all_ous["Workloads/Reserved"].arn]
        # }
        Infrastructure_Dev = {
          name                 = "Infrastructure_Dev"
          cidr                 = [element(local.region1_cidrs, 4)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Test = {
          name                 = "Infrastructure_Test"
          cidr                 = [element(local.region1_cidrs, 5)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Prod = {
          name                 = "Infrastructure_Prod"
          cidr                 = [element(local.region1_cidrs, 6)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        # Infrastructure_Reserved = {
        #   name                 = "Infrastructure_Reserved"
        #   cidr                 = [element(local.region1_cidrs, 7)]
        #   ram_share_principals = [local.all_ous["Infrastructure"].arn]
        # }
        Sandbox = {
          name                 = "Sandbox"
          cidr                 = [element(local.region1_cidrs, 8)]
          ram_share_principals = [local.all_ous["Sandbox"].arn]
        }
        Exception = {
          name                 = "Exception"
          cidr                 = [element(local.region1_cidrs, 9)]
          ram_share_principals = [local.all_ous["Exception"].arn]
        }
        Security = {
          name                 = "Security"
          cidr                 = [element(local.region1_cidrs, 10)]
          ram_share_principals = [local.all_ous["Security"].arn]
        }
        Deployments = {
          name                 = "Deployments"
          cidr                 = [element(local.region1_cidrs, 11)]
          ram_share_principals = [local.all_ous["Deployments"].arn]
        }
        Policy_Staging = {
          name                 = "Policy_Staging"
          cidr                 = [element(local.region1_cidrs, 12)]
          ram_share_principals = [local.all_ous["Policy Staging"].arn]
        }
      }
    }

    (local.global_vars.region2) = {
      cidr   = [local.region2_pool]
      name   = local.global_vars.region2
      locale = local.global_vars.region2

      sub_pools = {
        Workloads_Dev = {
          name                 = "Workloads_Dev"
          cidr                 = [element(local.region2_cidrs, 0)]
          ram_share_principals = [local.all_ous["Workloads/Dev"].arn]
        }
        Workloads_Test = {
          name                 = "Workloads_Test"
          cidr                 = [element(local.region2_cidrs, 1)]
          ram_share_principals = [local.all_ous["Workloads/Test"].arn]
        }
        Workloads_Prod = {
          name                 = "Workloads_Prod"
          cidr                 = [element(local.region2_cidrs, 2)]
          ram_share_principals = [local.all_ous["Workloads/Prod"].arn]
        }
        # Workloads_Reserved = {
        #   name                 = "Workloads_Reserved"
        #   cidr                 = [element(local.region2_cidrs, 3)]
        #   ram_share_principals = [local.all_ous["Workloads/Reserved"].arn]
        # }
        Infrastructure_Dev = {
          name                 = "Infrastructure_Dev"
          cidr                 = [element(local.region2_cidrs, 4)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Test = {
          name                 = "Infrastructure_Test"
          cidr                 = [element(local.region2_cidrs, 5)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Prod = {
          name                 = "Infrastructure_Prod"
          cidr                 = [element(local.region2_cidrs, 6)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        # Infrastructure_Reserved = {
        #   name                 = "Infrastructure_Reserved"
        #   cidr                 = [element(local.region2_cidrs, 7)]
        #   ram_share_principals = [local.all_ous["Infrastructure"].arn]
        # }
        Sandbox = {
          name                 = "Sandbox"
          cidr                 = [element(local.region2_cidrs, 8)]
          ram_share_principals = [local.all_ous["Sandbox"].arn]
        }
        Exception = {
          name                 = "Exception"
          cidr                 = [element(local.region2_cidrs, 9)]
          ram_share_principals = [local.all_ous["Exception"].arn]
        }
        Security = {
          name                 = "Security"
          cidr                 = [element(local.region2_cidrs, 10)]
          ram_share_principals = [local.all_ous["Security"].arn]
        }
        Deployments = {
          name                 = "Deployments"
          cidr                 = [element(local.region2_cidrs, 11)]
          ram_share_principals = [local.all_ous["Deployments"].arn]
        }
        Policy_Staging = {
          name                 = "Policy_Staging"
          cidr                 = [element(local.region2_cidrs, 12)]
          ram_share_principals = [local.all_ous["Policy Staging"].arn]
        }
      }
    }

    (local.global_vars.region3) = {
      cidr   = [local.region3_pool]
      name   = local.global_vars.region3
      locale = local.global_vars.region3

      sub_pools = {
        Workloads_Dev = {
          name                 = "Workloads_Dev"
          cidr                 = [element(local.region3_cidrs, 0)]
          ram_share_principals = [local.all_ous["Workloads/Dev"].arn]
        }
        Workloads_Test = {
          name                 = "Workloads_Test"
          cidr                 = [element(local.region3_cidrs, 1)]
          ram_share_principals = [local.all_ous["Workloads/Test"].arn]
        }
        Workloads_Prod = {
          name                 = "Workloads_Prod"
          cidr                 = [element(local.region3_cidrs, 2)]
          ram_share_principals = [local.all_ous["Workloads/Prod"].arn]
        }
        # Workloads_Reserved = {
        #   name                 = "Workloads_Reserved"
        #   cidr                 = [element(local.region3_cidrs, 3)]
        #   ram_share_principals = [local.all_ous["Workloads/Reserved"].arn]
        # }
        Infrastructure_Dev = {
          name                 = "Infrastructure_Dev"
          cidr                 = [element(local.region3_cidrs, 4)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Test = {
          name                 = "Infrastructure_Test"
          cidr                 = [element(local.region3_cidrs, 5)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        Infrastructure_Prod = {
          name                 = "Infrastructure_Prod"
          cidr                 = [element(local.region3_cidrs, 6)]
          ram_share_principals = [local.all_ous["Infrastructure"].arn]
        }
        # Infrastructure_Reserved = {
        #   name                 = "Infrastructure_Reserved"
        #   cidr                 = [element(local.region3_cidrs, 7)]
        #   ram_share_principals = [local.all_ous["Infrastructure"].arn]
        # }
        Sandbox = {
          name                 = "Sandbox"
          cidr                 = [element(local.region3_cidrs, 8)]
          ram_share_principals = [local.all_ous["Sandbox"].arn]
        }
        Exception = {
          name                 = "Exception"
          cidr                 = [element(local.region3_cidrs, 9)]
          ram_share_principals = [local.all_ous["Exception"].arn]
        }
        Security = {
          name                 = "Security"
          cidr                 = [element(local.region3_cidrs, 10)]
          ram_share_principals = [local.all_ous["Security"].arn]
        }
        Deployments = {
          name                 = "Deployments"
          cidr                 = [element(local.region3_cidrs, 11)]
          ram_share_principals = [local.all_ous["Deployments"].arn]
        }
        Policy_Staging = {
          name                 = "Policy_Staging"
          cidr                 = [element(local.region3_cidrs, 12)]
          ram_share_principals = [local.all_ous["Policy Staging"].arn]
        }
      }
    }

    # (local.global_vars.region4) = {
    #   cidr   = [local.region4_pool]
    #   name   = local.global_vars.region4
    #   locale = local.global_vars.region4

    #   sub_pools = {
    #     Workloads_Dev = {
    #       name                 = "Workloads_Dev"
    #       cidr                 = [element(local.region4_cidrs, 0)]
    #       ram_share_principals = [local.all_ous["Workloads/Dev"].arn]
    #     }
    #     Workloads_Test = {
    #       name                 = "Workloads_Test"
    #       cidr                 = [element(local.region4_cidrs, 1)]
    #       ram_share_principals = [local.all_ous["Workloads/Test"].arn]
    #     }
    #     Workloads_Prod = {
    #       name                 = "Workloads_Prod"
    #       cidr                 = [element(local.region4_cidrs, 2)]
    #       ram_share_principals = [local.all_ous["Workloads/Prod"].arn]
    #     }
    #     # Workloads_Reserved = {
    #     #   name                 = "Workloads_Reserved"
    #     #   cidr                 = [element(local.region4_cidrs, 3)]
    #     #   ram_share_principals = [local.all_ous["Workloads/Reserved"].arn]
    #     # }
    #     Infrastructure_Dev = {
    #       name                 = "Infrastructure_Dev"
    #       cidr                 = [element(local.region4_cidrs, 4)]
    #       ram_share_principals = [local.all_ous["Infrastructure"].arn]
    #     }
    #     Infrastructure_Test = {
    #       name                 = "Infrastructure_Test"
    #       cidr                 = [element(local.region4_cidrs, 5)]
    #       ram_share_principals = [local.all_ous["Infrastructure"].arn]
    #     }
    #     Infrastructure_Prod = {
    #       name                 = "Infrastructure_Prod"
    #       cidr                 = [element(local.region4_cidrs, 6)]
    #       ram_share_principals = [local.all_ous["Infrastructure"].arn]
    #     }
    #     # Infrastructure_Reserved = {
    #     #   name                 = "Infrastructure_Reserved"
    #     #   cidr                 = [element(local.region4_cidrs, 7)]
    #     #   ram_share_principals = [local.all_ous["Infrastructure"].arn]
    #     # }
    #     Sandbox = {
    #       name                 = "Sandbox"
    #       cidr                 = [element(local.region4_cidrs, 8)]
    #       ram_share_principals = [local.all_ous["Sandbox"].arn]
    #     }
    #     Exception = {
    #       name                 = "Exception"
    #       cidr                 = [element(local.region4_cidrs, 9)]
    #       ram_share_principals = [local.all_ous["Exception"].arn]
    #     }
    #     Security = {
    #       name                 = "Security"
    #       cidr                 = [element(local.region4_cidrs, 10)]
    #       ram_share_principals = [local.all_ous["Security"].arn]
    #     }
    #     Deployments = {
    #       name                 = "Deployments"
    #       cidr                 = [element(local.region4_cidrs, 11)]
    #       ram_share_principals = [local.all_ous["Deployments"].arn]
    #     }
    #     Policy_Staging = {
    #       name                 = "Policy_Staging"
    #       cidr                 = [element(local.region4_cidrs, 12)]
    #       ram_share_principals = [local.all_ous["Policy Staging"].arn]
    #     }
    #   }
    # }
  }
}
