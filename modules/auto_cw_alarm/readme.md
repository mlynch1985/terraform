AWS CloudWatch Alarms Module
===========

A Terraform module that will deploy CloudWatch Alarms using Lambda functions triggerd by Cloudwatch Event rules

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `component` - Specify the application role for the ASG and EC2 instances.
- `auto_scaling_group_name` - Provide the friendly name of the AutoScalingGroup to monitor.

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

  namespace               = "useast1d"
  component               = "appdemo1"
  auto_scaling_group_name = "/useast1d/appdemo01/asg"

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
