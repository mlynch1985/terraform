Network Load Balancer Module
===========

A Terraform module that will deploy an AWS Network Load Balancer.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this NLB.
- `subnets` - Provide a list(string) of subnet IDs to deploy the NLB into.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the NLB resources. Defaults to `{}`.
- `is_internal` - Specify `false` to make the NLB public facing. Defaults to `true`.
- `enable_cross_zone_load_balancing` - "Set to `true` to allow the NLB to communicate across each availability zone. Defaults to `false`.

Usage
-----

```hcl
module "nlb" {
  source = "../modules/nlb"

  namespace                        = "useast1d"
  component                        = "appdemo1"
  subnets                          = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k", "subnet-1l2m3n4o5p"]
  is_internal                      = false
  enable_cross_zone_load_balancing = true

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

- `nlb` - Outputs the [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) object.

Authors
----------------------

awsml@amazon.com
