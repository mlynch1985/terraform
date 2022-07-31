# IPAM Module

This module creates an IPAM Pool and allocates one CIDR into the current region.

---

## Required Input Variables

- **None**

---

## Optional Input Variables

- `allocation_default_netmask_length` - Specify the default netmask length for new VPC CIDRs. Default is `20`.
- `allocation_max_netmask_length` - Specify the maximum netmask length for new VPC CIDRs. Default is `28`.
- `allocation_min_netmask_length` - Specify the minimum netmask length for new VPC CIDRs. Default is `16`.
- `ipam_cidr` - Specify the IPAM Pool CIDR. Default is `10.0.0.0/8`.

---

## Output Variables

- `ipam_id` - The IPAM [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam#id)
- `ipam_arn` - The IPAM [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam#arn)
- `pool_id` - The IPAM Pool [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#id)
- `pool_arn` - The IPAM Pool [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool#arn)
- `cidr` - The IPAM Pool [CIDR](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_ipam_pool_cidr#cidr)

---

## Usage

```hcl
module "ipam_pool" {
  source = "./modules/ipam"

  allocation_default_netmask_length = 20
  allocation_max_netmask_length     = 28
  allocation_min_netmask_length     = 16
  ipam_cidr                         = "10.0.0.0/8"
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
