Application Load Balancer Module
===========

A Terraform module that will deploy an AWS Application Load Balancer.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this ALB.
- `security_groups` - Provide a list(string) of security group IDs.
- `subnets` - Provide a list(string) of subnet IDs to deploy the ALB into.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `is_internal` - Specify `false` to make the ALB public facing. Defaults to `true`.

Usage
-----

```hcl
module "alb" {
  source = "../modules/alb"

  namespace       = "useast1d"
  component       = "appdemo1"
  security_groups = ["sg-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  subnets         = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k", "subnet-1l2m3n4o5p"]
  is_internal     = false

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

- `alb` - Outputs the [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) object.

Authors
----------------------

awsml@amazon.com
