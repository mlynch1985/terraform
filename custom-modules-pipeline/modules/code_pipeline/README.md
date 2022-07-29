# CodePipeline Module

## Description

This module will create a CodePipeline pipeline that will pull the latest commit from the `main` branch of a CodeCommit repository and copy the contents into an S3 bucket.

----

## Usage

```bash
module "code_pipeline" {
  source = "./modules/code_pipeline"

  codepipeline_name = {STRING}         # Provide a friendly name for your CodePipeline pipeline
  role_arn          = {IAM_ROLE_ARN}   # Provide an IAM Role ARN used to execute this pipeline
  role_name         = {IAM_ROLE_ARN}   # Provide the IAM Role Name to attach new IAM Policies to
  bucket_name       = {STRING}         # Provide an S3 Bucket Name to store artifacts and logs for this pipeline
  pipeline_key_arn  = {KMS_KEY_ARN}    # Provide a KMS Customer Managed Key (CMK) ARN to encrypt the pipeline
  codecommit_arn    = {CODECOMMIT_ARN} # Provide the CodeCommit Repository ARN to pull the source code from
  codecommit_name   = {STRING}         # Provide the CodeCommit Repository Name to pull the source code from
  codebuild_name    = {STRING}         # Provide the CodeBuild Project Name to trigger within this pipeline
}
```

----

## Outputs

- `id` - This module outputs the ID of the CodePipeline
- `arn` - This module outputs the ARN of the CodePipeline

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
