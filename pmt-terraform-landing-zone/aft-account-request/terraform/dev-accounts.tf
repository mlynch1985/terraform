# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "dev_app01" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "<alias>+demo-dev-app01@amazon.com"
    AccountName               = "Dev-App01"
    ManagedOrganizationalUnit = "Dev (<OU ID>)"
    SSOUserEmail              = "<alias>@amazon.com"
    SSOUserFirstName          = "FNAME"
    SSOUserLastName           = "LNAME"
  }

  account_tags = {
    "Name"  = "App01"
    "Owner" = "App Team 01"
  }

  change_management_parameters = {
    change_requested_by = "FNAME LNAME"
    change_reason       = "Onboarding"
  }

  account_customizations_name = "workloads-dev"
}

module "dev_app02" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "<alias>+demo-dev-app02@amazon.com"
    AccountName               = "Dev-App02"
    ManagedOrganizationalUnit = "Dev (<OU ID>)"
    SSOUserEmail              = "<alias>@amazon.com"
    SSOUserFirstName          = "FNAME"
    SSOUserLastName           = "LNAME"
  }

  account_tags = {
    "Name"  = "App02"
    "Owner" = "App Team 02"
  }

  change_management_parameters = {
    change_requested_by = "FNAME LNAME"
    change_reason       = "Onboarding"
  }

  account_customizations_name = "workloads-dev"
}
