# EFS File System Module

This module creates an EFS File System and Mount Targets.

---

## Required Input Variables

- `enable_lifecycle_policy` - Set to `true` to enable an EFS lifecycle policy.
- `iam_role` - Please specify an IAM Role to be granted access to the EFS Share.
- `performance_mode` - Specify the EFS File System performance mode.
- `security_groups` - Provide a list of security group IDs to attach to the EFS share.
- `subnets` - Specify a list of subnet IDs to create mount targets in.
- `throughput_mode` - Specify the EFS File System throughput mode.

---

## Optional Input Variables

- `kms_key_arn` - Specify the KMS Key ARN to encrypt the file system. Defaults to `""`.
- `provisioned_throughput` - Specify the desired amount in MIBs of throughput. Defaults to `0`.

---

## Output Variables

- `id` - The EFS File System [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#id)
- `arn` - The EFS File System [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#arn)
- `dns_name` - The EFS File System [DNS Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system#dns_name)

---

## Usage

```hcl
module "efs" {
  source = "./modules/efs"

  # Require Parameters
  enable_lifecycle_policy = true
  iam_role                = "arn:aws:iam::us-east-1:role/my-test-role"
  performance_mode        = "generalPurpose"
  security_groups         = ["sg-1a2b3c4d5e6f7g"]
  subnets                 = ["subnet-1a2b3c4d5e6f7g8h", "subnet-9i0j1k2l3m4n5o6p"]
  throughput_mode         = "bursting"

  # Optional Parameters
  kms_key_arn            = ""
  provisioned_throughput = 0
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
