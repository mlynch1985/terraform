# S3 Bucket Module

## Description

This module will create an S3 Bucket with KMS Encryption and Versioning enabled. Additionally, we will create a Bucket Policy that will grant basic read/write access to a provided list of IAM Role ARNs.

----

## Usage

```bash
module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = {STRING}           # Provide a globally unique name for this bucket
  key_arn     = {KMS_KEY_ARN}      # Provide a KMS Customer Managed Key (CMK) ARN to encrypt this bucket
  iam_roles   = list[IAM_ROLE_ARN] # Provide a list of IAM Role ARNs to be granted access to this bucket
}
```

----

## Outputs

- `arn` - This module outputs the ARN of the S3 Bucket
- `name` - This module outputs the Name of the S3 Bucket

----

## Authors

Mike Lynch (mlynch1985@gmail.com)
