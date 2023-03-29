terraform {
  required_version = ">= 1.0"

  cloud {
    organization = "lynchbros"

    workspaces {
      name = "aft"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

module "aft-initiator" {
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.9.2"

  ct_management_account_id                        = "525260847144"
  aft_management_account_id                       = "067521573221"
  audit_account_id                                = "203495621194"
  log_archive_account_id                          = "890487267480"
  ct_home_region                                  = "us-east-2"
  tf_backend_secondary_region                     = "us-east-1"
  vcs_provider                                    = "github"
  account_customizations_repo_branch              = "main"
  account_customizations_repo_name                = "awsml-axiamed-organization/aft-account-customizations"
  account_provisioning_customizations_repo_branch = "main"
  account_provisioning_customizations_repo_name   = "awsml-axiamed-organization/aft-account-provisioning-customizations"
  account_request_repo_branch                     = "main"
  account_request_repo_name                       = "awsml-axiamed-organization/aft-account-request"
  global_customizations_repo_branch               = "main"
  global_customizations_repo_name                 = "awsml-axiamed-organization/aft-global-customizations"
  aft_feature_cloudtrail_data_events              = false
  aft_feature_delete_default_vpcs_enabled         = true
  aft_feature_enterprise_support                  = false
  aft_metrics_reporting                           = true
  cloudwatch_log_group_retention                  = 7
  maximum_concurrent_customizations               = 10
  terraform_version                               = "1.4.2"
}
