terraform {
  required_version = ">= 1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.27"
    }
  }

  backend "s3" {
    region         = "us-east-1"
    bucket         = "{STATE_BUCKET}"
    key            = "{STATE_FULE}"
    dynamodb_table = "{DYNAMODB_TABLE}"
    encrypt        = "true"
    kms_key_id     = "{KMS_KEY}"
  }
}

provider "aws" {
  region = "us-east-1"
}


# Reference: https://github.com/aws-ia/terraform-aws-control_tower_account_factory
module "aft-initiator" {
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.10.3"

  # Account IDs
  ct_management_account_id  = "{ACCOUNT_ID}"
  aft_management_account_id = "{ACCOUNT_ID}"
  audit_account_id          = "{ACCOUNT_ID}"
  log_archive_account_id    = "{ACCOUNT_ID}"

  # VCS Configuration
  vcs_provider                                    = "github"
  account_customizations_repo_branch              = "main"
  account_customizations_repo_name                = "{GITHUB_ORGANIZATION}/aft-account-customizations"
  account_provisioning_customizations_repo_branch = "main"
  account_provisioning_customizations_repo_name   = "{GITHUB_ORGANIZATION}/aft-account-provisioning-customizations"
  account_request_repo_branch                     = "main"
  account_request_repo_name                       = "{GITHUB_ORGANIZATION}/aft-account-request"
  global_customizations_repo_branch               = "main"
  global_customizations_repo_name                 = "{GITHUB_ORGANIZATION}/aft-global-customizations"


  # AFT Configuration
  ct_home_region                          = "us-east-1"
  tf_backend_secondary_region             = "us-west-2"
  aft_feature_cloudtrail_data_events      = true
  aft_feature_delete_default_vpcs_enabled = true
  aft_feature_enterprise_support          = true
  aft_metrics_reporting                   = true
  aft_vpc_endpoints                       = true
  cloudwatch_log_group_retention          = 90
  maximum_concurrent_customizations       = 10
  terraform_version                       = "1.5.7" # Released Aug, 2023
}
