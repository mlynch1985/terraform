AWS CloudWatch Agent Module
===========

A Terraform module that will deploy CloudWatch Agent configs into Parameter store for both Windows and Linux platforms.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for the ASG and EC2 instances.
- `iam_role_name` - Provide the EC2 Instance Role Name to associate the CloudWatchServerAgent policy with.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `linux_config` - Provide the path to a Linux CWA config json file.
- `windows_config` - Provide the path to a Windows CWA config json file.

Usage
-----

```hcl
module "cwa" {
  source = "../modules/cwa"

  namespace      = "useast1d"
  component      = "appdemo1"
  iam_role_name  = "useast1d_appdemo01_ec2_role"
  linux_config   = "file("${path.module}/linux_config.json")"
  windows_config = "file("${path.module}/windows_config.json")"

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

- `none`

Authors
----------------------

awsml@amazon.com
