EC2 Instance Module
===========

A Terraform module that will deploy a single AWS EC2 Instance.

Required Input Variables
----------------------

- `namespace` - Define a value in all lowercase number and letters only (ex. useast1d).
- `app_role` - Specify the application role for this instance.
- `image_id` - Specify an AMI ID used to launch EC2 instances.
- `security_groups` - Provide a list(string) of security group IDs to associate with this instance.
- `subnet_id` - Provide a subnet ID of where this instance should be deployed.

Optional Input Variables
----------------------

- `default_tags` - Provide a map(string) or tags to associate with the ALB
resources. Defaults to `{}`.
- `instance_type` - Specify the EC2 instance type. Defaults to `t3.medium`.
- `key_name` - Provide the name of an existing EC2 Key Pair. Defaults to `""`.
- `enable_detailed_monitoring` - Set to `true` to enable Cloudwatch detailed monitoring. Defaults to `false`.
- `associate_public_ip_address` - Set to true to enable a Public IP address for this instance. Instance must be deployed in a Public Subnet. Defaults to `false`.
- `user_data` - Provide path to a userdata script. Defaults to `""`.
- `iam_instance_profile` - Specify the name to an IAM Instance Profile. Defaults to `""`.
- `root_block_device` - Provide a map(string) defining a root block device mapping.
- `ebs_block_device` - Provide a map(string) defining a secondary EBS block device mapping.
- `enable_second_drive` - Set to `true` if you want to enable a second drive. If `true`, you must also provide a mapping to `ebs_block_device`.

Usage
-----

```hcl
module "ec2_instance" {
  source = "../modules/ec2_instance"

  namespace                   = "useast1d"
  app_role                    = "appdemo1"
  image_id                    = data.aws_ami.amazon_linux_2.image_id
  security_groups             = [aws_security_group.ec2.id]
  subnet_id                   = tolist(data.aws_subnet_ids.private.ids)[0]
  instance_type               = "t3.large"
  key_name                    = "appdemo01-key"
  enable_detailed_monitoring  = true
  associate_public_ip_address = false
  user_data                   = filebase64("${path.module}/userdata.sh")
  iam_instance_profile        = module.ec2_role.profile.name
  enable_second_drive         = true

  default_tags =  {
    namespace: "useast1d"
    app_role: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }

  root_block_device = {
    device_name: "/dev/xvda/"
    volume_type: "gp2"
    volume_size: "30"
    delete_on_termination: true
    encrypted: true
  }

  ebs_block_device = {
    device_name: "/dev/xvdb/"
    volume_type: "gp2"
    volume_size: "50"
    delete_on_termination: false
    encrypted: true
  }
}
```

Outputs
----------------------

- `None`

Authors
----------------------

awsml@amazon.com
