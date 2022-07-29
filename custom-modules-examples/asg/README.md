AutoScaling Group Module
===========

A Terraform module that will deploy an AWS AutoScaling Group and link it to a TargetGroup.

Required Input Variables
----------------------

- `image_id` - Specify the AMI ID of the image to be used for each EC2 instance.
- `instance_type` - Specify the EC2 instance size.
- `server_name` - Specify the server name to used for the Name Tag.
- `vpc_security_group_ids` - Provide a list of security group IDs to attach to this instance.
- `kms_key_arn` - Provide the KMS Key ARN used to encrypt the EBS Volumes.
- `subnets` - List of subnet IDs to launch instances in.

Optional Input Variables
----------------------

- `user_data` - Specify a path to a userdata script. Defaults to `""`.
- `block_device_mappings` - Specify a list of block device mappings to attach to each instance. Defaults to `[]`.
- `iam_instance_profile` - Please specify the iam instance profile arn to attach to each EC2 instance. Defaults to `""`.
- `max_size` - The maximum size of the auto scaling group. Defaults to `1`.
- `min_size` - The minimum size of the auto scaling group. Defaults to `1`.
- `healthcheck_grace_period` - Time in seconds after instance launch before performing healthchecks. Defaults to `300`.
- `healthcheck_type` - Specify `EC2` or `ELB` to determine how healthchecks should be performed. Defaults to `EC2`.
- `desired_capacity` - The desired capacity of the auto scaling group. Defaults to `1`.
- `target_group_arns` - A list of target group ARNs to associated instances with. Defaults to `[]`.

Usage
-----

```hcl
module "asg" {
  source = "./modules/asg"

  image_id                  = "ami-0a1b2c3d4e5f6g7h8i9"
  instance_type             = "c5.xlarge"
  server_name               = "app_server"
  vpc_security_group_ids    = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]
  kms_key_arn               = var.kms_key_arn
  subnets                   = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k"]

  user_data                 = filebase64("${path.module}/userdata.sh")
  iam_instance_profile      = var.iam_role.instance_profle
  min_size                  = 1
  max_size                  = 1
  healthcheck_grace_period  = 300
  healthcheck_type          = "EC2"
  desired_capacity          = 1
  target_group_arns         = []

  block_device_mappings = [
    {
      device_name: "/dev/xvda"
      volume_type: "gp3"
      volume_size: "50"
      iops: null
      delete_on_termination: true
    },
    {
      device_name: "xvdf"
      volume_type: "gp3"
      volume_size: "100"
      iops: null
      delete_on_termination: true
    }
  ]
}
```

Outputs
----------------------

- `id` - The AutoScalingGroup ID
- `arn` - The AutoScalingGroup ARN
- `name` - The AutoScalingGroup Name

Authors
----------------------

mlynch1985@gmail.com
