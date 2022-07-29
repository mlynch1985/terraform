EC2 Instance Module
===========

A Terraform module that will deploy a single AWS EC2 Instance.

Required Input Variables
----------------------

- `namespace` - Specify a stack namespace to prefix all resources.
- `component` - Provide an application role to label each resource within this module.
- `image_id` - Specify the AMI ID of the image to be used for each EC2 instance.
- `instance_type` - Specify the EC2 instance size.
- `security_groups` - Provide a list of security group IDs to attach to this instance.
- `subnet_id` - Provide a subnet ID to deploy EC2 instances into.

Optional Input Variables
----------------------

- `availability_zone` - The AZ to start the instance in. Defaults to `""`.
- `placement_group` - The placement group to start the instance in. Defaults to `""`.
- `tenancy` - Define where this instance is on a Shared or Dedicated host. Defaults to `"default"`.
- `host_id` - The ID of the dedicated host that the instance will be assigned to. Defaults to `""`.
- `cpu_core_count` - Sets the number of cores for the instance. Defaults to `null`.
- `cpu_threads_per_core` - Set to 1 to disable hyperthreading or 2 to enable it. Defaults to `2`.
- `disable_api_termination` - Set to true to prevent termination of instance via API calls. Defaults to `false`.
- `key_name` - Specify the key name to attach and allow access to each EC2 instance. Defaults to `""`.
- `monitoring` - Set to true to enable detailed monitoring at 1 minute intervals. Defaults to `false`.
- `associate_public_ip_address` - Set to true to enable Public IP Address assignment, must also select Public subnet. Defaults to `false`.
- `private_ip` - Specify the Private IP address to associate to this instance. Defaults to `""`.
- `source_dest_check` - Set to false to allow traffic not destined for this instance. Defaults to `true`.
- `user_data` - Specify a path to a userdata script. Defaults to `""`.
- `iam_instance_profile` - Please specify the iam instance profile arn to attach to each EC2 instance. Defaults to `""`.
- `default_tags` - Specify a map of tags to add to all resources. Defaults to `{}`.
- `root_block_device` - Specify a list of EBS block mapping for the root block drive. Limit is 1 for root device. Defaults to `[]`.
- `ebs_block_device` - Specify a list of EBS block mappings for additional block drives. Defaults to `[]`.

Usage
-----

```hcl
module "ec2_instance" {
  source = "../../modules/ec2_instance"

  namespace                   = "useast1d"
  component                   = "appdemo1"
  image_id                    = "ami-0a1b2c3d4e5f6g7h8i9"
  instance_type               = "c5.xlarge"
  security_groups             = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]
  subnet_id                   = "subnet-1a2b3c4d5e"

  availability_zone           = "us-east-1a"
  placement_group             = "group-1"
  tenancy                     = "shared"
  host_id                     = ""
  cpu_core_count              = 4
  cpu_threads_per_core        = 2
  disable_api_termination     = false
  key_name                    = "my-key"
  monitoring                  = false
  associate_public_ip_address = false
  private_ip                  = "10.0.0.15"
  source_dest_check           = true
  user_data                   = filebase64("${path.module}/userdata.sh")
  iam_instance_profile        = "arn:aws:iam::012345678901:instance-profile/~"

  default_tags = {
    namespace: "useast1d"
    component: "appdemo01"
    lob: "business"
    team: "operations"
    environemnt: "developement"
  }

  root_block_device = [
    {
      volume_type: "gp2"
      volume_size: "30"
      iops: null
      delete_on_termination: true
      encrypted: false
    }
  ]

  ebs_block_device = [
    {
      device_name: "xvdf"
      volume_type: "io2"
      volume_size: "100"
      iops: 3000
      delete_on_termination: true
      encrypted: false
    },
    {
      device_name: "xvdg"
      volume_type: "io2"
      volume_size: "100"
      iops: 3000
      delete_on_termination: true
      encrypted: false
    }
  ]
}
```

Outputs
----------------------

- `instance` - Outputs the [aws_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) object.

Authors
----------------------

mlynch1985@gmail.com
