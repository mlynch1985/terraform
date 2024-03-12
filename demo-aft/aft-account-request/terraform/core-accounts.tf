# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "ct_management" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+aftdemo-ct-management@amazon.com"
    AccountName               = "CT-Management"
    ManagedOrganizationalUnit = "Root"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Name"  = "CT-Management"
    "Owner" = "Cloud Sec Ops"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Onboarding"
  }

  account_customizations_name = "account-ct-management"
}

module "audit" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+aftdemo-audit@amazon.com"
    AccountName               = "Audit"
    ManagedOrganizationalUnit = "Security"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Name"  = "Audit"
    "Owner" = "Cloud Sec Ops"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Onboarding"
  }

  account_customizations_name = "account-audit"
}

# module "log_archive" {
#   source = "./modules/aft-account-request"

#   control_tower_parameters = {
#     AccountEmail              = "awsml+aftdemo-log-archive@amazon.com"
#     AccountName               = "Log Archive"
#     ManagedOrganizationalUnit = "Security"
#     SSOUserEmail              = "awsml@amazon.com"
#     SSOUserFirstName          = "Mike"
#     SSOUserLastName           = "Lynch"
#   }

#   account_tags = {
#     "Name"  = "Log Archive"
#     "Owner" = "Cloud Sec Ops"
#   }

#   change_management_parameters = {
#     change_requested_by = "Mike Lynch"
#     change_reason       = "Onboarding"
#   }

#   account_customizations_name = "account-log-archive"
# }

# module "aft_management" {
#   source = "./modules/aft-account-request"

#   control_tower_parameters = {
#     AccountEmail              = "awsml+aftdemo-aft-management@amazon.com"
#     AccountName               = "AFT-Management"
#     ManagedOrganizationalUnit = "Deployments"
#     SSOUserEmail              = "awsml@amazon.com"
#     SSOUserFirstName          = "Mike"
#     SSOUserLastName           = "Lynch"
#   }

#   account_tags = {
#     "Name"  = "AFT-Management"
#     "Owner" = "Cloud Sec Ops"
#   }

#   change_management_parameters = {
#     change_requested_by = "Mike Lynch"
#     change_reason       = "Onboarding"
#   }

#   account_customizations_name = "account-aft-management"
# }

# module "network" {
#   source = "./modules/aft-account-request"

#   control_tower_parameters = {
#     AccountEmail              = "awsml+aftdemo-network@amazon.com"
#     AccountName               = "Network"
#     ManagedOrganizationalUnit = "Infrastructure"
#     SSOUserEmail              = "awsml@amazon.com"
#     SSOUserFirstName          = "Mike"
#     SSOUserLastName           = "Lynch"
#   }

#   account_tags = {
#     "Name"  = "Network"
#     "Owner" = "Cloud Sec Ops"
#   }

#   change_management_parameters = {
#     change_requested_by = "Mike Lynch"
#     change_reason       = "Onboarding"
#   }

#   account_customizations_name = "account-network"
# }
