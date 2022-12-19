# KMS Key Module

This module will create a single or multi region KMS key and key alias.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `enable_key_rotation` | Boolean | No | `true` | Set to `true` if you would like the KMS Key to rotate each year |
| `enable_multi_region` | Boolean | No | `false` | Set to `true` if this KMS Key should be available in multiple regions |
| `iam_roles` | list(String) | Yes | N/A | Provide a list of IAM Role ARNs to be granted KMS Key Usage access in the key policy |
| `key_name` | string | Yes | N/A | Provide a friendly name to identify this KMS Key in the console |

---

## Output Variables

| Name | Resource Type | Description |
| ---- | ------------- | ----------- |
| `id` | [KMS Key ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#id) | The `ID` of the new KMS Key |
| `arn` | [KMS Key ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn) | The `ARN` of the new KMS Key |
| `name` | [KMS Key Alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias#name) | The `Key Alias` of the new KMS Key |

---

## Usage

```hcl
module "kms_key" {
  source = "./modules/kms_key"

  enable_key_rotation = true
  enable_multi_region = false
  iam_roles = [var.iam_role1.arn, var.iam_role2.arn, var.iam_role3.arn]
  key_name  = "use1d/app1_bucket"
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
