# © 2024 Amazon Web Services, Inc. or its affiliates. All Rights Reserved.
# This AWS Content is provided subject to the terms of the AWS Customer Agreement available at
# http://aws.amazon.com/agreement or other written agreement between Customer and either
# Amazon Web Services, Inc. or Amazon Web Services EMEA SARL or both.

module "aft-initiator" {
  source  = "aws-ia/control_tower_account_factory/aws"
  version = "1.12.0"

  # Account Info
  ct_management_account_id  = local.ct_management_account_id
  aft_management_account_id = local.aft_management_account_id
  audit_account_id          = local.audit_account_id
  log_archive_account_id    = local.log_archive_account_id
  ct_home_region            = local.ct_home_region

  # AFT Configuration
  aft_feature_cloudtrail_data_events      = true
  aft_feature_enterprise_support          = false
  aft_feature_delete_default_vpcs_enabled = true
  aft_metrics_reporting                   = true
  backup_recovery_point_retention         = 30 # days
  cloudwatch_log_group_retention          = 30 # days
  concurrent_account_factory_actions      = 5
  global_codebuild_timeout                = 180 # minutes
  maximum_concurrent_customizations       = 10

  # AFT VPC Configuration
  aft_enable_vpc                 = true
  aft_vpc_endpoints              = true
  aft_vpc_cidr                   = "192.168.0.0/22"
  aft_vpc_private_subnet_01_cidr = "192.168.0.0/24"
  aft_vpc_private_subnet_02_cidr = "192.168.1.0/24"
  aft_vpc_public_subnet_01_cidr  = "192.168.2.0/24"
  aft_vpc_public_subnet_02_cidr  = "192.168.3.0/24"

  # VCS Configuration
  # github_enterprise_url                           = ""
  aft_framework_repo_url                          = "https://github.com/aws-ia/terraform-aws-control_tower_account_factory.git"
  aft_framework_repo_git_ref                      = "main"
  vcs_provider                                    = "codecommit"
  account_customizations_repo_branch              = local.branch_name
  account_customizations_repo_name                = "aft-account-customizations"
  account_provisioning_customizations_repo_branch = local.branch_name
  account_provisioning_customizations_repo_name   = "aft-account-provisioning-customizations"
  account_request_repo_branch                     = local.branch_name
  account_request_repo_name                       = "aft-account-request"
  global_customizations_repo_branch               = local.branch_name
  global_customizations_repo_name                 = "aft-global-customizations"

  # Terraform Configuration
  tf_backend_secondary_region = local.ct_secondary_region
  terraform_api_endpoint      = "https://app.terraform.io/api/v2/"
  terraform_distribution      = "oss"
  terraform_org_name          = "null"
  terraform_token             = "null"
  terraform_version           = "1.7.4"
}

resource "aws_iam_role_policy" "aft_admin_role" {
  provider   = aws.aft-management
  depends_on = [module.aft-initiator]
  role       = "AWSAFTAdmin"
  name       = "custom_stop_codebuild_execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "codebuild:StopBuild"
        Resource = [
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.aft-management.account_id}:project/aft-global-customizations-terraform",
          "arn:aws:codebuild:${data.aws_region.current.name}:${data.aws_caller_identity.aft-management.account_id}:project/aft-account-customizations-terraform"
        ]
        Condition = {
          StringEquals = {
            "aws:ResourceTag/managed_by" = ["AFT"]
          }
        }
      }
    ]
  })
}

data "external" "customize_codebuild_jobs" {
  program = ["python", "./customize_codebuild_jobs.py"]
  query = {
    aft_account_id = local.aft_management_account_id
    aws_region     = local.ct_home_region
  }
  depends_on = [module.aft-initiator]
}
