AWS Systems Manager Patching Module
===========

A Terraform module that will deploy an AWS SSM maintenance window and patching task targeting EC2 instances.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for this ALB.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB
resources. Defaults to `{}`.
- `schedule_name` - Specify a name for this maintance window. Defaults to `"daily_patching"`.
- `schedule_cron` - Specify a cron expression to define how often this maintenance will execute. Defaults to `"cron(0 0 ? * * *)"`.
- `schedule_timezone` - Provide a timezone name for which the maintenance window should use. Defaults to `"America/New_York"`.
- `schedule_cutoff` - Define the number of hours before the end of the maintenance window to stop executing new tasks. Defaults to `0`.
- `schedule_duration` - Define the number of hours to execute the maintenance window. Defaults to `4`.
- `target_tag_name` - Specify the tag name of EC2 instances to associate with the maintenance window. Defaults to `"tag:enable_patching"`.
- `target_tag_value` - Specify the tag value of EC2 instances to associate with the maintenance window. Defaults to `"true"`.
- `max_concurrency` - Define how many maintenance tasks can be performed in parallel. Defaults to `5`.
- `max_errors` - Define how many errors can be encountered before stopping the maintenance windows. Defaults to `3`.

Usage
-----

```hcl
module "patching" {
  source = "../modules/patching"

  namespace         = "useast1d"
  app_role          = "appdemo1"
  schedule_name     = "daily_patching"
  schedule_cron     = "cron(0 0 ? * * *)"
  schedule_timezone = "America/New_York"
  schedule_cutoff   = 2
  schedule_duration = 6
  target_tag_name   = "tag:enable_patching"
  target_tag_value  = "true"
  max_concurrency   = 5
  max_errors        = 3

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
