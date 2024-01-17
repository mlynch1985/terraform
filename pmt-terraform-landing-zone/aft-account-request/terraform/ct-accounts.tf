# # © 2023 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# # This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# # http://aws.amazon.com/agreement or other written agreement between Customer and either
# # Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.


module "ct_management" {
  source                      = "./modules/aft-account-request"
  account_customizations_name = "account-root"

  control_tower_parameters = {
    AccountEmail              = "{ALIAS}+{CUSTOMER_NAME}-management@amazon.com"
    AccountName               = "Management"
    ManagedOrganizationalUnit = "Root"
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

module "ct_audit" {
  source                      = "./modules/aft-account-request"
  account_customizations_name = "account-audit"

  control_tower_parameters = {
    AccountEmail              = "{ALIAS}+{CUSTOMER_NAME}-audit@amazon.com"
    AccountName               = "Audit"
    ManagedOrganizationalUnit = "Security"
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

module "ct_log_archive" {
  source                      = "./modules/aft-account-request"
  account_customizations_name = "account-log-archive"

  control_tower_parameters = {
    AccountEmail              = "{ALIAS}+{CUSTOMER_NAME}-log-archive@amazon.com"
    AccountName               = "Log Archive"
    ManagedOrganizationalUnit = "Security"
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
