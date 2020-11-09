Network Load Balancer Module
===========

A Terraform module that will deploy an AWS Network Load Balancer instance and define a listener.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for this NLB.
- `subnets` - Provide a list(string) of subnet IDs to deploy the NLB into.
- `vpc_id` - The vpc ID where this NLB instance should be deployed.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the NLB resources. Defaults to `{}`.
- `is_internal` - Specify `false` to make the NLB public facing. Defaults to `true`.
- `enable_cross_zone_load_balancing` - "Set to `true` to allow the NLB to communicate across each availability zone. Defaults to `false`.
- `target_group_port` - Specify the port number to connect to the target group on. Defaults to `80`.
- `target_group_protocol` - Specify either `"HTTP"` or `"HTTPS"`. Defaults to `"HTTP"`.
- `deregistration_delay` - Set to a nunmber in seconds for how long the NLB should drain connections before removing it from the NLB. Defaults to `300`.
- `enable_stickiness` - Set to `true` to enable sticky sessions. Defaults to `false`.
- `healthcheck_path` - Provide the url path to perform a healthcheck. Defaults to `"/"`.
- `nlb_listener_port` - Define the port number the NLB should listen on. Defaults to `80`.
- `nlb_listener_protocol` - Define the protocol the NLB should listen on. Defaults to `"HTTP"`.
- `nlb_listener_cert` - Provide an ARN pointing to an SSL Certificate stored in AWS Certification Manager (ACM). Defaults to `""`.

Usage
-----

```hcl
module "nlb" {
  source = "../modules/nlb"

  namespace             = "useast1d"
  app_role              = "appdemo1"
  security_groups       = [aws_security_group.nlb.id]
  subnets               = data.aws_subnet_ids.public.ids
  vpc_id                = data.aws_vpc.this.id
  is_internal           = false
  target_group_port     = 80
  target_group_protocol = "HTTP"
  deregistration_delay  = 300
  enable_stickiness     = true
  healthcheck_path      = "/healthcheck.html"
  nlb_listener_port     = 80
  nlb_listener_protocol = "HTTP"
  nlb_listener_cert     = ""

  default_tags         =  {
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

- `nlb` - Outputs the [aws_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) object.
- `target_group` - Outputs the [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) object.
- `listener` - Outputs the [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) object.

Authors
----------------------

awsml@amazon.com
