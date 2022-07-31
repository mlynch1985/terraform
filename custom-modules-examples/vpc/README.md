AWS VPC Module
===========

This module will provision either a `hub` or `spoke` type VPC with either `public` Networking components or `Transit Gateway` Components

Required Input Variables
----------------------

- `namespace` - Specify a stack namespace to prefix all resources
- `environment` - Specify a stack environment to prefix all resources
- `cidr_block` - Specify the VPC cidr block

Optional Input Variables
----------------------

- `enable_dns_hostnames` - Set to `true` to enable VPC hostname support. Defaults to `true`.
- `enable_dns_support` - Set to `true` to enable VPC DNS support. Defaults to `true`.
- `enable_flow_logs` - Set to `true` to enable VPC Flow Logs. Defaults to `true`.
- `subnet_size_offset` - Define the subnet offset based on vpc cidr. Defaults to `8`.
- `target_az_count` - Specify the number of availability zones to deploy subnets into. Defaults to `3`.
- `tgw_id` - If creating a `hub` VPC then you must specify an existing Transit Gateway ID. Defult to `""`.
- `vpc_type` - Set to `hub` or `spoke` to determine if we should create Public Tier or connect to existing TGW. Defaults to `hub`
- `ipam_pool_id` - .

Usage
-----

```hcl
module "vpc" {
  source = "s3::https://s3.amazonaws.com/${S3_Bucket_Name}/vpc.zip"

  namespace            = "use1"
  environment          = "dev"
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_flow_logs     = true
  subnet_size_offset   = 8
  target_az_count      = 3
  tgw_id               = ""
  vpc_type             = "hub"

}
```

Outputs
----------------------

- `vpc` - Outputs the [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) object.
- `default_security_group` - Outputs the [aws_default_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) object.
- `public_subnets` - Outputs the [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) object.
- `private_subnets` - Outputs the [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) object.

Authors
----------------------

mlynch1985@gmail.com
