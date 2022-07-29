# CodeBuild Module

## Description

This module will create a CodeBuild Project running on the latest AmazonLinux2 CodeBuild container and will checkout code from a CodeCommit Repository, scan the code using tflint, and then publish each Terraform module as a .zip file within an S3 Bucket.

----

## Usage

```bash
module "code_build_repo" {
  source = "./modules/code_build"

  codebuild_name = {STRING}         # Provide a friendly name for your CodeBuild Project
  role_arn       = {IAM_ROLE_ARN}   # Provide the IAM Role ARN to be used by the CodeBuild Project
  role_name      = {STRING}         # Provide the IAM Role Name to attach new IAM Policies to
  bucket_name    = {STRING}         # Provide the name of the S3 Bucket to publish the TF Modules into
  codecommit_arn = {CODECOMMIT_ARN} # Provide the CodeCommit Repository ARN to pull the source code from
}
```

----

## Outputs

- `arn` - This module outputs the CodeBuild Project ARN
- `name` - This module outputs the CodeBuild Project Name

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
