S3 Bucket Module
===========

This module will create an S3 Bucket with KMS Encryption and Versioning Enabled.  Additionally a bucket policy will grant access to a list of IAM Roles.

Required Input Variables
----------------------

- `bucket_name` - Specify a globally unique bucket name
- `key_arn` - Specify the full ARN of a KMS Key to be used to encryption bucket objects
- `iam_roles` - Provide a list of IAM Role ARNs to grant bucket access

Optional Input Variables
----------------------

- None

Usage
-----

```hcl
module "s3_bucket" {
  source = "./modules/s3_bucket"

  bucket_name = "use1/dev/app1_bucket"
  key_arn     = var.kms_key.arn
  iam_roles   = [var.iam_role1, var.iam_role2, var.iam_role3]
}
```

Outputs
----------------------

- `name` - The S3 Bucket Name

Authors
----------------------

mlynch1985@gmail.com
