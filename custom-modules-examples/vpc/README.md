# AWS VPC Module

This module will provision either a `hub` or `spoke` VPC with either `public` components or `Transit Gateway` components.

---

## Required Input Variables

- `environment` - Specify an environment to identify the current deployment.
- `namespace` - Specify a namespace to identify the current deployment.

---

## Optional Input Variables

- `cidr_block` - Specify a valid VPC CIDR. Defaults to `""`.
- `enable_dns_hostnames` - Set to `true` to enable VPC hostnames. Defaults to `true`.
- `enable_dns_support` - Set to `true` to enable VPC DNS support. Defaults to `true`.
- `enable_flow_logs` - Set to `true` to enable VPC Flow Logs. Defaults to `true`.
- `ipam_pool_id` - Specify an IPAM Pool ID to allocate a CIDR. Defaults to `""`.
- `ipam_pool_netmask` - Specify a NetMask to define the size of the VPC CIDR. Defaults to `16`.
- `subnet_size_offset` - Define the subnet mask offset based on VPC CIDR. Defaults to `8`.
- `target_az_count` - Specify the number of availability zones to deploy subnets into. Defaults to `3`.
- `tgw_id` - If creating a `hub` VPC then you must specify an existing Transit Gateway ID. Defaults to `""`.
- `vpc_type` - Set to `hub` or `spoke` to determine if we should create Public Tier or connect to existing TGW. Defaults to `hub`.

---

## Output Variables

- `vpc` - Outputs the [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) object.
- `default_security_group` - Outputs the [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) object.
- `public_subnets` - Outputs the [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) object.
- `private_subnets` - Outputs the [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) object.

---

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"

  # Required Parameters
  environment = "dev"
  namespace   = "use1d"

  # Optional Parameters
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  ipam_pool_id         = ""
  ipam_pool_netmask    = null
  subnet_size_offset   = 8
  target_az_count      = 3
  tgw_id               = ""
  vpc_type             = "hub"
}
```

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
