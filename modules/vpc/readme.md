AWS VPC Module
===========

A Terraform module that will deploy an AWS VPC, with an Internet Gateway and a public subnet per availability zone.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB
resources. Defaults to `{}`.
- `cidr_block` - Specify the VPC cidr block. Should be between a /16 and a /28 cidr. Defaults to `"10.0.0.0/16"`.
- `enable_dns_support` - Set to `true` to enable VPC DNS support. Defaults to `true`.
- `enable_dns_hostnames` - Set to `true` to enable VPC hostname support. Defaults to `true`.
- `target_az_count` - Specify the number of availability zones to deploy subnets into. Defaults to `3`.
- `deploy_private_subnets` - Set to `true` to enable private subnets and corresponding NAT Gateways. Defaults to `true`.
- `deploy_protected_subnets` - Set to `true` to enable protected subnets with no internet access. Defaults to `false`.
- `enable_flow_logs` - Set to `true` to enable VPC Flow Logs. Defaults to `false`.

Usage
-----

```hcl
module "vpc" {
  source = "../modules/vpc"

  namespace                = "useast1d"
  cidr_block               = "10.0.0.0/16"
  enable_dns_support       = true
  enable_dns_hostnames     = true
  target_az_count          = 3
  deploy_private_subnets   = true
  deploy_protected_subnets = false
  enable_flow_logs         = true

  default_tags =  {
    namespace: "useast1d"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }
}
```

Outputs
----------------------

- `vpc` - Outputs the aws_vpc object (Ref: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc>)
- `default_security_group` - Outputs the aws_vpc object (Ref: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group>)
- `public_subnets` - Outputs the aws_subnet.public object (Ref: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet>)
- `private_subnets` - Outputs the aws_subnet.private object (Ref: <https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet>)

Authors
----------------------

awsml@amazon.com
