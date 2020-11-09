AWS Managed AD Directory Service Module
===========

A Terraform module that will deploy an AWS Managed AD environment.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for the ASG and EC2 instances.
- `domain_name` - Specify a fully qualified domain name such as corp.example.com.
- `vpc_id` - Provide a VPC ID to target for this directory.
- `subnet_1` - Provide a subnet ID to deploy EC2 instances into.
- `subnet_2` - Provide a subnet ID to deploy EC2 instances into.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB
resources. Defaults to `{}`.
- `edition` - Set to either `"Standard"` or `"Enterprise"` to choose the version to deploy. Defaults to `"Standard"`.
- `enable_sso` - Set to `true` to enable single-sign on authentication for this directory. Defaults to `false`.

Usage
-----

```hcl
module "msad" {
  source = "../modules/msad"

  namespace   = "useast1d"
  app_role    = "appdemo1"
  domain_name = "example.com"
  vpc_id      = data.aws_vpc.this.id
  subnet_1    = tolist(data.aws_subnet_ids.private.ids)[0]
  subnet_2    = tolist(data.aws_subnet_ids.private.ids)[1]
  edition     = "Enterprise"
  enable_sso  = false

  default_tags =  {
    namespace: "useast1d"
    app_role: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }
}
```

Outputs
----------------------

- `directory_id` - Outputs the aws_directory_service_directory object's [directory_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) attribute.
- `dns_ip_addresses` - Outputs the aws_directory_service_directory object's [dns_ip_addresses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) attribute.

Authors
----------------------

awsml@amazon.com
