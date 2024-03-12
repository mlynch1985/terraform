# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

# module "dev_app01" {
#   source = "./modules/aft-account-request"

#   control_tower_parameters = {
#     AccountEmail              = "awsml+aftdemoapp01@amazon.com"
#     AccountName               = "App01"
#     ManagedOrganizationalUnit = "Dev (ou-uzcj-uznqhufq)"
#     SSOUserEmail              = "awsml@amazon.com"
#     SSOUserFirstName          = "Mike"
#     SSOUserLastName           = "Lynch"
#   }

#   account_tags = {
#     "Name"  = "App01"
#     "Owner" = "App Team 01"
#   }

#   change_management_parameters = {
#     change_requested_by = "Mike Lynch"
#     change_reason       = "Onboarding"
#   }

#   account_customizations_name = "workloads-dev"
# }

# module "dev_app02" {
#   source = "./modules/aft-account-request"

#   control_tower_parameters = {
#     AccountEmail              = "awsml+aftdemoapp02@amazon.com"
#     AccountName               = "App02"
#     ManagedOrganizationalUnit = "Dev (ou-uzcj-uznqhufq)"
#     SSOUserEmail              = "awsml@amazon.com"
#     SSOUserFirstName          = "Mike"
#     SSOUserLastName           = "Lynch"
#   }

#   account_tags = {
#     "Name"  = "App02"
#     "Owner" = "App Team 02"
#   }

#   change_management_parameters = {
#     change_requested_by = "Mike Lynch"
#     change_reason       = "Onboarding"
#   }

#   account_customizations_name = "workloads-dev"
# }
