Elastic File Share Module (EFS)
===========

A Terraform module that will deploy an AWS Elastic File Share with mount points in each subnet.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this instance.
- `subnets` - Provide a list of subnet IDs of where each mount point should be deployed.
- `security_groups` - Provide a list(string) of security group IDs to associate with this instance.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `is_encrypted` - Set to `true` to enable encryption. Defaults to `false`.
- `performance_mode` - Set to either `"generalPurpose"` or `"maxIO"`. Defaults to `"generalPurpose"`.

Usage
-----

```hcl
module "efs" {
  source = "../modules/efs"

  namespace        = "useast1d"
  component         = "appdemo1"
  subnets          = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k", "subnet-1l2m3n4o5p"]
  security_groups  = ["sg-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  is_encrypted     = false
  performance_mode = "generalPurpose"

  default_tags = {
    namespace: "useast1d"
    component: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }
```

Outputs
----------------------

- `None`

Authors
----------------------

mlynch1985@gmail.com
