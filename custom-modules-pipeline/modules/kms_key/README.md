# KMS Key Module

## Description

This module will create a single region KMS Key for use by our S3 Buckets and CodeBuild/CodePipline.

----

## Usage

```bash
module "kms_key" {
  source = "./modules/kms_key"

  key_name  = {STRING}           # Provide a friendly name to be used as the Key Alias
  iam_roles = list[IAM_ROLE_ARN] # Provide a list of IAM Role ARNs to be granted usage rights for this key
}
```

----

## Outputs

- `arn` - This module outputs the ARN of the KMS Key
- `key_id` - This module outputs the ID of the KMS Key

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
