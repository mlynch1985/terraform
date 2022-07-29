# EventBridge Module

## Description

This module will create an EventBridge Rule that will trigger on a merge or commit into the `main` branch of a CodeCommit Repository and will execute a CodePipeline pipeline

----

## Usage

```bash
module "event_bridge" {
  source = "./modules/eventbridge"

  role_arn          = {IAM_ROLE_ARN}      # Provide an IAM Role ARN used to execute this pipeline
  codecommit_name   = {STRING}            # Provide the CodeCommit Repository Name to pull the source code from
  codepipeline_arn  = {CODE_PIPELINE_ARN} # PRovide the CodePipeline Pipeline ARN to trigger
}
```

----

## Outputs

NONE

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
