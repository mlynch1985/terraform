# EFS File System Module

This module creates an EFS File System and Mount Targets.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `enable_lifecycle_policy` | Boolean | Yes | `false` | If set to `true` this will enable a 30 Day LifeCycle Policy that transitions to Infrequent Access Tier (Allowed Values: `true` \| `false`) |
| `iam_roles` | list(String) | Yes | N/A | Provide a list of IAM Role ARNs to grant access to the EFS Share |
| `kms_key_arn` | String | No | `null` | Provide a KMS Key ARN to be used to encrypt the EFS share, otherwise encryption will not be enabled |
| `performance_mode` | String | No | `generalPurpose` | Select which mode to deploy the EFS share (Allowed Values: `generalPurpose` \| `maxIO`)
| `provisioned_throughput` | Number | No | `125` | If `throughput_mode` is set to `provisioned` this variable is mandatory. Specify the number of MiB/s to provision (Allowed Values: 1-1024) |
| `security_groups` | list(String) | Yes | N/A | Provide a list of Security Group IDs to attach to the EFS share |
| `subnets` | list(String) | Yes | N/A | Provide a list of Subnet IDs to provision Mount Targets into |
| `throughput_mode` | String | No | `elastic` | Select the method to manage throughput limits (Allowed Values: `bursting` \| `elastic` \| `provisioned`) |

---

## Output Variables

| Name | Resource Type | Description |
| ---- | ------------- | ----------- |
| `id` | [EFS Share ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#id) | The `ID` of the new EFS Share |
| `arn` | [EFS Share ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#arn) | The `ARN` of the new EFS Share |
| `dns_name` | [EFS Share DNS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#dns_name) | The `DNS` of the new EFS Share |

---

## Usage

```hcl
module "efs" {
  source = "./modules/efs"

  enable_lifecycle_policy = false
  iam_roles               = ["arn:aws:iam::us-east-1:role/my-test-role"]
  kms_key_arn             = "arn:aws:kms:us-east-1:123456789012:key/1a2b3c4d-1a2b-3c4d-5e6f-1a2b3c4d5e6f"
  performance_mode        = "generalPurpose"
  provisioned_throughput  = 125
  security_groups         = ["sg-1a2b3c4d5e6f7g"]
  subnets                 = ["subnet-1a2b3c4d5e6f7g8h", "subnet-9i0j1k2l3m4n5o6p"]
  throughput_mode         = "elastic"
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
