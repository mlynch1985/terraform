AutoScaling Group Module
===========

A Terraform module that will deploy an AWS AutoScaling Group and link it to a TargetGroup.

Required Input Variables
----------------------

- `namespace` - Specify a stack namespace to prefix all resources.
- `component` - Provide an application role to label each resource within this module.
- `subnets` - List of subnet IDs to launch instances in.
- `image_id` - Specify the AMI ID of the image to be used for each EC2 instance.
- `instance_type` - Specify the EC2 instance size.
- `vpc_security_group_ids` - Provide a list of security group IDs to attach to this instance.

Optional Input Variables
----------------------

- `min_size` - The minimum size of the auto scaling group. Defaults to `1`.
- `max_size` - The maximum size of the auto scaling group. Defaults to `1`.
- `desired_capacity` - The desired capacity of the auto scaling group. Defaults to `1`.
- `capacity_rebalance` - Allows to the capacity to be balanced across the AZs. Defaults to `false`.
- `default_cooldown` - The amoung of time in seconds between scaling events. Defaults to `null`.
- `healthcheck_grace_period` - Time in seconds after instance launch before performing healthchecks. Defaults to `300`.
- `healthcheck_type` - Specify `EC2` or `ELB` to determine how healthchecks should be performed. Defaults to `EC2`.
- `force_delete` - Allow ASG to terminate before all instances have been terminated. Defaults to `false`.
- `target_group_arns` - A list of target group ARNs to associated instances with. Defaults to `[]`.
- `termination_policies` - A list of policies to decide how instances in ASG should be terminated. Defaults to `"Default"`.
- `default_tags` - Specify a map of tags to add to all resources. Defaults to `{}`.
- `wait_for_capacity_timeout` - Max duration Terraform should wait for instances to be healthy. Defaults to `"10m"`.
- `protect_from_scale_in` - Prevents instances from be terminated due to a scale in operation. Defaults to `false`.
- `update_default_version` - Set to true to overwrite Default version or false to create a new version. Defaults to `true`.
- `block_device_mappings` - Specify a list of block device mappings to attach to each instance. Defaults to `[]`.
- `disable_api_termination` - Set to true to prevent termination of instance via API calls. Defaults to `false`.
- `iam_instance_profile` - Please specify the iam instance profile arn to attach to each EC2 instance. Defaults to `""`.
- `key_name` - Specify the key name to attach and allow access to each EC2 instance. Defaults to `""`.
- `monitoring` - Set to true to enable detailed monitoring at 1 minute intervals. Defaults to `false`.
- `user_data` - Specify a path to a userdata script. Defaults to `""`.

Usage
-----

```hcl
module "asg" {
  source = "../../modules/asg"

  namespace                 = "useast1d"
  component                 = "appdemo1"
  subnets                   = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  image_id                  = "ami-0a1b2c3d4e5f6g7h8i9"
  instance_type             = "c5.xlarge"
  vpc_security_group_ids    = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]

  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  capacity_rebalance        = false
  default_cooldown          = null
  healthcheck_grace_period  = 300
  healthcheck_type          = "EC2"
  force_delete              = false
  target_group_arns         = []
  termination_policies      = ["Default"]
  wait_for_capacity_timeout = "10m"
  protect_from_scale_in     = false
  update_default_version    = true
  disable_api_termination   = false
  iam_instance_profile      = "arn:aws:iam::012345678901:instance-profile/~"
  key_name                  = "my-key"
  monitoring                = false
  user_data                 = filebase64("${path.module}/userdata.sh")

  default_tags = {
    namespace: "useast1d"
    component: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }

  ebs_block_device = [
    {
      device_name: "/dev/xvda"
      volume_type: "gp2"
      volume_size: "50"
      iops: null
      delete_on_termination: true
      encrypted: true
    },
    {
      device_name: "xvdf"
      volume_type: "gp3"
      volume_size: "100"
      iops: null
      delete_on_termination: true
      encrypted: false
    }
  ]
}
```

Outputs
----------------------

- `asg` - Outputs the [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) object.
- `launch_template` - Outputs the [aws_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) object.

Authors
----------------------

awsml@amazon.com
