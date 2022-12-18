# IPAM Module

This module creates an IPAM Pool and allocates one CIDR into the current region.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `allocation_default_netmask_length` | number | No | `20` | Specifies the default CIDR used to allocate new VPCs (Allowed Values: 16-26) |
| `allocation_max_netmask_length` | number | No | `26` | Specifies the maximum CIDR that can be allocated to new VPCs (Allowed Values: 18-28) |
| `allocation_min_netmask_length` | number | No | `16` | Specifies the minimum CIDR that can be allocated to new VPCs (Allowed Values: 16-26) |
| `ipam_cidr` | string | Yes | N/A | Specifies the CIDR for the initial IPAM Pool |
| `home_region` | string | Yes | `us-east-1` | Specify the AWS Region where the IPAM should be created |

---

| Name | Resource Type | Description |
| ---- | ------------- | ----------- |
| `ipam_id` | [IPAM ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam#id) | The `ID` of the new IPAM |
| `ipam_arn` | [IPAM ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam#arn) | The `ARN` of the new IPAM |
| `pool_id` | [IPAM Pool ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#id) | The `ID` of the new IPAM Pool |
| `pool_arn` | [IPAM Pool ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#arn) | The `ARN` of the new IPAM Pool |
| `cidr` | [IPAM Pool CIDR](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#cidr) | The `CIDR` of the new IPAM Pool |

---

## Usage

```hcl
module "ipam_pool" {
  source = "./modules/ipam"

  allocation_default_netmask_length = 20
  allocation_max_netmask_length     = 26
  allocation_min_netmask_length     = 16
  ipam_cidr                         = "10.0.0.0/8"
  home_region                       = "us-east-1"
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
