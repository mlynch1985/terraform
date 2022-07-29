# IAM Role Module

## Description

This module will create an empty IAM Role with no policies attached.

----

## Usage

```bash
module "iam_role" {
  source = "./modules/iam_role"

  service     = {STRING} # Provide the AWS Service Name prefix (eg. before the .amazonaws.com)
  role_name   = {STRING} # Provide a friendly name for your new IAM Role
}
```

----

## Outputs

- `arn` - This module outputs the ARN of the IAM Role
- `name` - This module outputs the Name of the IAM Role

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
