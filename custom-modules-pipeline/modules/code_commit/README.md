# CodeCommit Module

## Description

This module will create a CodeCommit Repository used to develop custom Terraform Modules.

----

## Usage

```bash
module "code_commit_repo" {
  source = "./modules/code_commit"

  codecommit_name = {STRING} # Provide a friendly name for your CodeCommit Repository
}
```

----

## Outputs

- `arn` - This module outputs the CodeCommit Repository ARN
- `repository_id` - This module outputs the CodeCommit Repository ID
- `name` - This module outputs the CodeCommit Repository Name

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
