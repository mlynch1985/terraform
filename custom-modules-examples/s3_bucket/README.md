# S3 Bucket Module

This module creates an S3 Bucket.

---

## Required Input Variables

- `bucket_name` - Please specify a valid S3 Bucket Name that is globally unique.

---

## Optional Input Variables

- `iam_roles` - Specify a list of valid IAM Roles to be granted S3 Bucket Usage access. Defaults to `[]`.
- `key_arn` - Specify the KMS Key ARN to encrypt the bucket with. Defaults to `""`.
- `lifecycle_rules` - Specify a list of lifecycle rule maps. Defaults to `[]`.
- `versioning_option` - Specify the versioning option. Defaults to `""`.

---

## Output Variables

- `arn` - The S3 Bucket [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#arn)
- `domain_name` - The S3 Bucket [Domain Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#domain_name)
- `hosted_zone_id` - The S3 Bucket [Hosted Zone ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#hosted_zone_id)
- `name` - The S3 Bucket [Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#name)
- `regional_domain_name` - The S3 Bucket [Regional Domain Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#regional_domain_name)

---

## Usage

```hcl
module "s3_bucket" {
  source = "./modules/s3_bucket"

  # Required Parameters
  bucket_name = "use1d-dev-app1"

  # Optional Parameters
  iam_roles         = [var.iam_role1, var.iam_role2, var.iam_role3]
  key_arn           = var.kms_key.arn
  versioning_option = "Enabled"

  lifecycle_rules = [{
    id                       = "default"
    status                   = "Enabled"
    expire_days              = 90
    noncurrent_days          = 5
    noncurrent_storage_class = "GLACIER"
    noncurrent_versions      = 2
    transition_days          = 30
    transition_storage_class = "INTELLIGENT_TIERING"
  }]
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
