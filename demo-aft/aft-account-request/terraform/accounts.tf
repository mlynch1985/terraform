# # © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# # This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# # http://aws.amazon.com/agreement or other written agreement between Customer and either
# # Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "ct_management" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-ctmgmt@amazon.com"
    AccountName               = "CT-Management"
    ManagedOrganizationalUnit = "Root"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "Cloud Sec Ops"
    "Name"  = "CT-Management"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Refreshing"
  }

  account_customizations_name = "account-root"
}

module "audit" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-audit@amazon.com"
    AccountName               = "Audit"
    ManagedOrganizationalUnit = "Security"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "Cloud Sec Ops"
    "Name"  = "Audit"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Refreshing"
  }

  account_customizations_name = "account-audit"
}

module "log_archive" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-logarchive@amazon.com"
    AccountName               = "Log Archive"
    ManagedOrganizationalUnit = "Security"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "Cloud Sec Ops"
    "Name"  = "Log Archive"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Refreshing"
  }

  account_customizations_name = "account-log-archive"
}

module "aft_management" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-aftmgmt@amazon.com"
    AccountName               = "AFT-Management"
    ManagedOrganizationalUnit = "Deployments"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "Cloud Sec Ops"
    "Name"  = "AFT-Management"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Refreshing"
  }

  account_customizations_name = "account-aft-management"
}

module "network" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-network@amazon.com"
    AccountName               = "Network"
    ManagedOrganizationalUnit = "Infrastructure"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "Cloud Sec Ops"
    "Name"  = "Network"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Fixing Typo"
  }

  account_customizations_name = "account-network"
}

module "dev_app01" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-dev-app01@amazon.com"
    AccountName               = "Dev-App01"
    ManagedOrganizationalUnit = "Dev (ou-uzcj-uznqhufq)"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "App Team 01"
    "Name"  = "App01"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Initial Onboarding"
  }

  account_customizations_name = "workloads-dev"
}

module "dev_app02" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "awsml+demo-dev-app02@amazon.com"
    AccountName               = "Dev-App02"
    ManagedOrganizationalUnit = "Dev (ou-uzcj-uznqhufq)"
    SSOUserEmail              = "awsml@amazon.com"
    SSOUserFirstName          = "Mike"
    SSOUserLastName           = "Lynch"
  }

  account_tags = {
    "Owner" = "App Team 02"
    "Name"  = "App02"
  }

  change_management_parameters = {
    change_requested_by = "Mike Lynch"
    change_reason       = "Initial Onboarding"
  }

  account_customizations_name = "workloads-dev"
}
