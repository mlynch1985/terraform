IPAM Module
===========

This module will create an IPAM Pool

Required Input Variables
----------------------

- `region` - Specify the region to enable for this IPAM Pool
- `namespace` - Specify a namespace to be used to prefix the name of our resources
- `environment` - Specify a environment to be used to prefix the name of our resources

Optional Input Variables
----------------------

- `allocation_default_netmask_length` - Specify the default vpc netmask length. Default is `20`
- `allocation_min_netmask_length` - Specify the minimum vpc netmask length. Default is `16`
- `allocation_max_netmask_length` - Specify the maximum vpc netmask length. Default is `28`
- `ipam_cidr` - Specify the cidr range to be used for the IPAM Pool's private scope. Default is `10.0.0.0/8`

Usage
-----

```hcl
module "ipam_pool" {
  source = "./modules/ipam"

  region                            = "us-east-1"
  namespace                         = "use1"
  environment                       = "dev"
  allocation_default_netmask_length = 20
  allocation_min_netmask_length     = 16
  allocation_max_netmask_length     = 28
  ipam_cidr                         = "10.0.0.0/8
}
```

Outputs
----------------------

- `arn` - The ARN of the IPAM
- `id` - The id of the IPAM
- `cidr` - The cidr range of the IPAM

Authors
----------------------

mlynch1985@gmail.com
