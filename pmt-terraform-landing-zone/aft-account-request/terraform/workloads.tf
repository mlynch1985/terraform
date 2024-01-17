# # © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# # This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# # http://aws.amazon.com/agreement or other written agreement between Customer and either
# # Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


module "app01_nonprod" {
  source                      = "./modules/aft-account-request"
  account_customizations_name = "workloads"

  control_tower_parameters = {
    AccountEmail              = "{ALIAS}+{CUSTOMER_NAME}-app01@amazon.com"
    AccountName               = "App01"
    ManagedOrganizationalUnit = "Staging ({NESTED_OU_ID})"
    SSOUserEmail              = "{ALIAS}+{CUSTOMER_NAME}-management@amazon.com"
    SSOUserFirstName          = "AWS Control Tower"
    SSOUserLastName           = "Admin"
  }

  change_management_parameters = {
    change_requested_by = "CT ADMIN"
    change_reason       = "Initial Onboarding"
  }

  custom_fields = {}
}
