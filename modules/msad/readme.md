AWS Managed AD Directory Service Module
===========

A Terraform module that will deploy an AWS Managed AD environment.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for the ASG and EC2 instances.
- `domain_name` - Specify a fully qualified domain name such as corp.example.com.
- `vpc_id` - Provide a VPC ID to target for this directory.
- `subnet_1` - Provide a subnet ID to deploy EC2 instances into.
- `subnet_2` - Provide a subnet ID to deploy EC2 instances into.
- `iam_ec2_role` - Specify the name to an IAM EC2 Instance Role. Defaults to `""`.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `edition` - Set to either `"Standard"` or `"Enterprise"` to choose the version to deploy. Defaults to `"Standard"`.
- `enable_sso` - Set to `true` to enable single-sign on authentication for this directory. Defaults to `false`.
- `enable_auto_join` - Set to `true` to enable an SSM Association that will auto-join instances to AD. Defaults to `false`.
- `ad_target_tag_name` - Provide a tag name to filter on for the SSM Association. Defaults to `namespace`.
- `ad_target_tag_value` - Provide the tag value to filter on for the SSM Association. Defaults to `""`.

Usage
-----

```hcl
module "msad" {
  source = "../modules/msad"

  namespace           = "useast1d"
  component           = "appdemo1"
  domain_name         = "example.com"
  vpc_id              = "vpc-1a2b3c4d"
  subnet_1            = "subnet-1a2b3c4d5e"
  subnet_2            = "subnet-6f7g8h9i0k"
  edition             = "Standard"
  enable_sso          = false
  enable_auto_join    = false
  ad_target_tag_name  = "auto_join"
  ad_target_tag_value = "true"
  iam_ec2_role        = "sample-ec2-role"

  default_tags = {
    namespace: "useast1d"
    component: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }
}
```

Outputs
----------------------

- `directory` - Outputs the aws_directory_service_directory object [directory](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/directory_service_directory) attribute.

Authors
----------------------

awsml@amazon.com
