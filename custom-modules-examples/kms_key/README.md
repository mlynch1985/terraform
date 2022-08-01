# KMS Key Module

This module will create a single or multi region KMS key and key alias.

---

## Required Input Variables

- `iam_roles` - Specify a list of valid IAM Roles to be granted KMS Key Usage access.
- `key_name` - Specify a valid KMS Key Name to be used for the Alias.

---

## Optional Input Variables

- `enable_key_rotation` - Specify either `true` or `false` to enable automatic key rotation. Defaults to `true`.
- `enable_multi_region` - Specify either `true` or `false` to enable multi-region support. Defaults to `false`.

---

## Output Variables

- `id` - The KMS Key [Key ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#key_id)
- `arn` - The KMS Key [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key#arn)
- `name` - The KMS Key [Alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias#name)

---

## Usage

```hcl
module "kms_key" {
  source = "./modules/kms_key"

  # Required Parameters
  iam_roles           = [var.iam_role1.arn, var.iam_role2.arn, var.iam_role3.arn]
  key_name            = "use1d/app1_bucket"

  # Optional Parameters
  enable_key_rotation = true
  enable_multi_region = false
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
