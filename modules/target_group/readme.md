Application Load Balancer Module
===========

A Terraform module that will deploy an AWS Application Load Balancer instance and define a listener.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for this elb.
- `target_ids` - Provide a list of EC2 Instance IDs.
- `vpc_id` - The vpc ID where this elb instance should be deployed.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the elb resources. Defaults to `{}`.
- `target_group_port` - Specify the port number to connect to the target group on. Defaults to `80`.
- `target_group_protocol` - Specify either `"HTTP"` or `"HTTPS"`. Defaults to `"HTTP"`.
- `deregistration_delay` - Set to a nunmber in seconds for how long the elb should drain connections before removing it from the elb. Defaults to `300`.
- `enable_stickiness` - Set to `true` to enable sticky sessions. Defaults to `false`.
- `healthcheck_path` - Provide the url path to perform a healthcheck. Defaults to `"/"`.
- `elb_arn` - Provide the ARN to the ELB to associate with.
- `elb_listener_port` - Define the port number the elb should listen on. Defaults to `80`.
- `elb_listener_protocol` - Define the protocol the elb should listen on. Defaults to `"HTTP"`.
- `elb_listener_cert` - Provide an ARN pointing to an SSL Certificate stored in AWS Certification Manager (ACM). Defaults to `""`.
- `enable_healthcheck` - Set to `true` to enable ALB custom healthchecks. Defaults to `false`.

Usage
-----

```hcl
module "elb" {
  source = "../modules/elb"

  namespace             = "useast1d"
  component             = "appdemo1"
  target_ids            = ["i-1234567890", "i-0987654321"]
  target_group_port     = 80
  target_group_protocol = "HTTP"
  vpc_id                = "vpc-1a2b3c4d"
  deregistration_delay  = 300
  enable_stickiness     = false
  healthcheck_path      = "/"
  elb_listener_port     = 80
  elb_listener_protocol = "HTTP"
  elb_listener_cert     = ""
  enable_healthcheck    = false

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

- `target_group` - Outputs the [aws_lb_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) object.
- `listener` - Outputs the [aws_lb_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) object.

Authors
----------------------

awsml@amazon.com
