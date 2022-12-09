terraform {
  cloud {
    organization = "lynchbros"

    workspaces {
      name = "aft"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.40.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Creator      = var.creator
      Environment  = var.environment
      Namespace    = var.namespace
      Organization = var.organization
      Owner        = var.owner
    }
  }
}

data "aws_caller_identity" "current" {}

# module "control_tower_account_factory" {
module "aft-initiator" {
  # source = "git@github.com:aws-ia/terraform-aws-control_tower_account_factory.git"
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.6.7"

  aft_feature_cloudtrail_data_events      = false
  aft_feature_delete_default_vpcs_enabled = true
  aft_feature_enterprise_support          = false
  aft_management_account_id               = "067521573221"
  aft_metrics_reporting                   = true
  audit_account_id                        = "203495621194"
  cloudwatch_log_group_retention          = 30
  ct_home_region                          = var.region
  ct_management_account_id                = data.aws_caller_identity.current.account_id
  log_archive_account_id                  = "890487267480"
  tf_backend_secondary_region             = "us-east-1"
}
