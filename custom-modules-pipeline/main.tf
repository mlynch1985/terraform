terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
}


provider "aws" {
  // Define which region to deploy this stack into
  region = var.region

  // Define the default tags to be associated with each resource in this stack
  default_tags {
    tags = {
      Primary_Owner       = var.primary_owner
      Secondary_Owner     = var.secondary_owner
      Business_Unit       = var.business_unit
      Cost_Center         = var.cost_center
      Application_Name    = var.application_name
      Application_ID      = var.application_id
      Application_Version = var.application_version
      Namespace           = var.namespace
      Environment         = var.environment
      Project_Name        = var.project_name
      Security_Tier       = var.security_tier
      Patching_Tier       = var.patching_tier
    }
  }
}

// Create an IAM Role needed to execute our CodeBuild jobs
module "iam_role_codebuild" {
  source = "./modules/iam_role"

  service   = "codebuild"
  role_name = "${var.namespace}-${var.environment}-${var.project_name}-codebuild"
}

// Create an IAM Role needed to execute our CodePipeline
module "iam_role_codepipeline" {
  source = "./modules/iam_role"

  service   = "codepipeline"
  role_name = "${var.namespace}-${var.environment}-${var.project_name}-codepipeline"
}

// Create an IAM Role needed to capture CodeCommit events and trigger our CodePipeline
module "iam_role_eventbridge" {
  source = "./modules/iam_role"

  service   = "events"
  role_name = "${var.namespace}-${var.environment}-${var.project_name}-eventbridge"
}

// Create a single region KMS Customer Managed Key used to encrypt our CodePipeline S3 Bucket
module "kms_key_pipeline" {
  source = "./modules/kms_key"

  key_name  = "${var.namespace}/${var.environment}/${var.project_name}-pipeline"
  iam_roles = [module.iam_role_codebuild.arn, module.iam_role_codepipeline.arn]
}

// Create a single region KMS Customer Managed Key used to encrypt our Modules S3 Bucket
module "kms_key_modules" {
  source = "./modules/kms_key"

  key_name  = "${var.namespace}/${var.environment}/${var.project_name}-modules"
  iam_roles = [module.iam_role_codebuild.arn, module.iam_role_codepipeline.arn]
}

// Create an S3 Bucket to store artifacts and logs generated during our CodePipeline execution
module "s3_bucket_pipeline" {
  source = "./modules/s3_bucket"

  bucket_name = "${var.namespace}-${var.environment}-${var.project_name}-pipeline"
  key_arn     = module.kms_key_pipeline.arn
  iam_roles   = [module.iam_role_codebuild.arn, module.iam_role_codepipeline.arn]
}

// Create an S3 Bucket to store the Terraform Modules we would like to make available to our development or platform teams
module "s3_bucket_modules" {
  source = "./modules/s3_bucket"

  bucket_name = "${var.namespace}-${var.environment}-${var.project_name}-modules"
  key_arn     = module.kms_key_modules.arn
  iam_roles   = [module.iam_role_codebuild.arn, module.iam_role_codepipeline.arn]
}

// Create a CodeCommit Repository to store the source code of our custom Terraform Modules that will then be uploaded to the S3 Bucket
module "code_commit_repo" {
  source = "./modules/code_commit"

  codecommit_name = "${var.namespace}-${var.environment}-${var.project_name}"
}

// Create our CodeBuild job to zip up the CodeCommit source code into modules and push to the S3 Bucket
module "code_build" {
  source = "./modules/code_build"

  codebuild_name = "${var.namespace}-${var.environment}-${var.project_name}"
  role_arn       = module.iam_role_codebuild.arn
  role_name      = module.iam_role_codebuild.name
  bucket_name    = module.s3_bucket_modules.name
  codecommit_arn = module.code_commit_repo.arn
}

// Create a CodePipeline that will trigger on a CodeCommit push that will then execute our CodeBuild job
module "code_pipeline" {
  source = "./modules/code_pipeline"

  codepipeline_name = "${var.namespace}-${var.environment}-${var.project_name}"
  role_arn          = module.iam_role_codepipeline.arn
  role_name         = module.iam_role_codepipeline.name
  bucket_name       = module.s3_bucket_pipeline.name
  pipeline_key_arn  = module.kms_key_pipeline.arn
  codecommit_arn    = module.code_commit_repo.arn
  codecommit_name   = module.code_commit_repo.name
  codebuild_name    = module.code_build.name
}

// Create the EventBus event to capture the push to our CodeCommit Repository and then trigger the CodePipeline
module "event_bridge" {
  source = "./modules/eventbridge"

  role_arn         = module.iam_role_eventbridge.arn
  role_name        = module.iam_role_eventbridge.name
  codecommit_name  = module.code_commit_repo.name
  codepipeline_arn = module.code_pipeline.arn
}
