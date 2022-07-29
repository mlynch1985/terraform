KMS Key Module
===========

This module will create a single or multi region KMS Key and Key Alias

Required Input Variables
----------------------

- `key_name` - Specify a friendly name excluding "alias/" to be assigned to the Key Alias
- `iam_roles` - Provide a list of IAM Role ARNs to grant key usage permission

Optional Input Variables
----------------------

- `enable_multi_region` - Specify either `true` or `false` to enable this KMS key to be multi-region. Defaults to `false`

Usage
-----

```hcl
module "kms_key" {
  source = "./modules/kms"

  key_name            = "use1/dev/app1_bucket"
  iam_roles           = [var.iam_role1, var.iam_role2, var.iam_role3]
  enable_multi_region = false
}
```

Outputs
----------------------

- `arn` - The ARN of the KMS Key
- `name` - The KMS Key Alias name

Authors
----------------------

mlynch1985@gmail.com
