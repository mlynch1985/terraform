Elastic Load Balancer Module
===========

A Terraform module that will deploy an AWS Elastic Load Balancer.

Required Input Variables
----------------------

- `namespace` - Specify a stack namespace to prefix all resources.
- `component` - Provide an app role to label each resource within this module.
- `load_balancer_type` - Specify either application or network.
- `subnets` - Provide a list of subnets to apply to elb.

Optional Input Variables
----------------------

- `security_groups` - Provide a list of security groups to apply to elb. Defaults to `[]`.
- `drop_invalid_header_fields` - Remove HTTP headers with invalid fields. Defaults to `false`.
- `idle_timeout` - Time in seconds connections can be idle. Defaults to `60`.
- `enable_http` - Enables HTTP/2 traffic on ALB. Defaults to `true`.
- `enable_cross_zone_load_balancing` - Allows NLB to distribute traffic across AZs. Defaults to `false`.
- `internal` - Specify `false` to make the ELB public facing. Defaults to `true`.
- `enable_deletion_protection`- Prevents termination using API calls. Defaults to `false`.
- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.

Usage
-----

```hcl
module "elb" {
  source = "../modules/elb"

  namespace                  = "useast1d"
  component                  = "appdemo1"
  load_balancer_type         = "application"
  subnets                    = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k", subnet-1l2m3n4o5p"]

  security_groups            = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]
  drop_invalid_header_fields = false
  idle_timeout               = 60
  enable_http2               = true

  is_internal                = false
  enable_deletion_protection = false

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

- `elb` - Outputs the [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) object.

Authors
----------------------

awsml@amazon.com
