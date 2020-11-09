AWS CloudWatch Agent Module
===========

A Terraform module that will deploy CloudWatch Agent configs into Parameter store for both Windows and Linux platforms.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for the ASG and EC2 instances.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB
resources. Defaults to `{}`.

Usage
-----

```hcl
module "cwa" {
  source = "../modules/cwa"

  namespace = "useast1d"
  app_role  = "appdemo1"

  default_tags = {
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

- `none`

Authors
----------------------

awsml@amazon.com
