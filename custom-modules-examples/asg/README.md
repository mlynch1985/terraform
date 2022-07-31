# AutoScaling Group Module

This module creates a Launch Template and an Auto Scaling Group.

---

## Required Input Variables

- `image_id` - Specify the AMI ID of the image to be used for each EC2 instance.
- `instance_type` - Specify the EC2 instance size.
- `kms_key_arn` - Provide the KMS Key ARN used to encrypt the EBS Volumes.
- `server_name` - Specify the server name to used for the Name Tag.
- `subnets` - List of subnet IDs to launch instances in.
- `vpc_security_group_ids` - Provide a list of security group IDs to attach to this instance.

---

## Optional Input Variables

- `block_device_mappings` - Specify a list of block device mappings to attach to each instance. Defaults to `[]`.
- `desired_capacity` - The desired capacity of the auto scaling group. Defaults to `1`.
- `healthcheck_grace_period` - Time in seconds after instance launch before performing healthchecks. Defaults to `300`.
- `healthcheck_type` - Specify `EC2` or `ELB` to determine how healthchecks should be performed. Defaults to `EC2`.
- `iam_instance_profile` - Please specify the iam instance profile arn to attach to each EC2 instance. Defaults to `""`.
- `max_size` - The maximum size of the auto scaling group. Defaults to `1`.
- `min_size` - The minimum size of the auto scaling group. Defaults to `1`.
- `user_data` - Specify a path to a userdata script. Defaults to `""`.

---

## Usage

```hcl
module "asg" {
  source = "./modules/asg"

  # Required Parameters
  image_id                  = "ami-0a1b2c3d4e5f6g7h8i9"
  instance_type             = "c5.xlarge"
  kms_key_arn               = "arn:aws:kms:us-east-1:123456789012:key/1a2b3c4d-1a2b-3c4d-5e6f-1a2b3c4d5e6f"
  server_name               = "app_server"
  subnets                   = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  vpc_security_group_ids    = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]

  # Optional Parameters
  desired_capacity          = 3
  healthcheck_grace_period  = 300
  healthcheck_type          = "ELB"
  iam_instance_profile      = "arn:aws:iam::123456789012:instance-profile/ec2_instance_profile"
  max_size                  = 6
  min_size                  = 1

  block_device_mappings = [
    {
      device_name: "/dev/xvda"
      volume_type: "gp3"
      volume_size: "50"
      iops: "3000"
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

  # Inline User Data Script
  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum upgrade -y
    yum install -y httpd
    echo "Hello World from $(hostname -f)" > /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    EOF
  )

  # Local File User Data Script
  # user_data = filebase64("userdata.sh")
}
```

---

## Outputs

- `id` - The AutoScalingGroup [ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#id)
- `arn` - The AutoScalingGroup [ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#arn)
- `name` - The AutoScalingGroup [Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#name)

---

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
