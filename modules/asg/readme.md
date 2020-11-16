AutoScaling Group Module
===========

A Terraform module that will deploy an AWS AutoScaling Group and link it to a TargetGroup.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for the ASG and EC2 instances.
- `image_id` - Specify an AMI ID used to launch EC2 instances.
- `security_groups` - Provide a list(string) of security group IDs.
- `asg_subnets` - Provide a list(string) of subnet IDs to deploy the ALB into.
- `target_group_arns` - Provide a list(string) of TargetGroup ARNs to associated this ASG with.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB resources. Defaults to `{}`.
- `instance_type` - Specify the EC2 instance type. Defaults to `t3.medium`.
- `key_name` - Provide the name of an existing EC2 Key Pair. Defaults to `""`.
- `user_data` - Provide path to a userdata script. Defaults to `""`.
- `block_device_mapping` - Provide a map(string) defining a block device mapping. Root or secondary drive can be specified, but not both.
- `enable_detailed_monitoring` - Set to `true` to enable Cloudwatch detailed monitoring. Defaults to `false`.
- `iam_instance_profile` - Specify the name to an IAM Instance Profile. Defaults to `""`.
- `asg_min` - Define the minimum number of instances for the ASG. Defaults to `1`.
- `asg_max` - Define the maximum number of instances for the ASG. Defaults to `1`.
- `asg_desired` - Define the desired number of instances for the ASG. Defaults to `1`.
- `asg_healthcheck_type` - Specify either `"EC2"` or `"ELB"` for the type of healthcheck to perform.  Defaults to `"EC2"`.

Usage
-----

```hcl
module "asg" {
  source = "../modules/asg"

  namespace                  = "useast1d"
  app_role                   = "appdemo1"
  image_id                   = "ami-0a1b2c3d4e5f6g7h8i9"
  security_groups            = ["sg-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  asg_subnets                = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k", "subnet-1l2m3n4o5p"]
  target_group_arns          = ["arn:aws:elasticloadbalancing:us-east-1:012345678901:targetgroup/~"]
  instance_type              = "t3.medium"
  key_name                   = ""
  user_data                  = filebase64("${path.module}/userdata.sh")
  enable_detailed_monitoring = false
  iam_instance_profile       = "arn:aws:iam::012345678901:instance-profile/~"
  asg_min                    = 1
  asg_max                    = 1
  asg_desired                = 1
  asg_healthcheck_type       = "EC2"

  default_tags = {
    namespace: "useast1d"
    app_role: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }

  block_device_mapping = {
    device_name: "/dev/xvda/"
    volume_type: "gp2"
    volume_size: "30"
    delete_on_termination: true
    encrypted: false
  }
}
```

Outputs
----------------------

- `asg` - Outputs the [aws_autoscaling_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) object.

Authors
----------------------

awsml@amazon.com
