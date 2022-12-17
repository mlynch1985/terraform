# AutoScalingGroup Module

This module creates a Launch Template and an Auto Scaling Group. Optionally it will create a Target Group.

---

## Input Variables

| Name | Type | Required | Default | Description |
| ---- | ---- | -------- | ------- | ----------- |
| `block_device_mappings` | list(object) | No | [See Below](#block-device-mappings) | A list of Block Device Mapping Objects to be attached |
| `healthcheck_grace_period` | Number | No | `300` | The time in seconds after launching the EC2 Instance before healthchecks are performed |
| `healthcheck_type` | String | No | `EC2` | The type of healthcheck to be performed on the EC2 Instances (Allowed Values: `EC2` \| `ELB`) |
| `iam_instance_profile` | String | No | `""` | The IAM Instance Profile Name to be attached to each EC2 Instance |
| `image_id` | String | Yes | N/A | The AMI ID to use when launching the EC2 Instances |
| `instance_type` | String | Yes | `t3.micro` | The EC2 Instance Type/Size |
| `max_size` | Number | No | `1` | The maximum count of EC2 Instances that can be launched |
| `min_size` | Number | No | `1` | The minimum count of EC2 Instances that should be created |
| `server_name` | String | Yes | N/A | The label used when creating the `Name` tag |
| `subnets` | list(String) | Yes | N/A | A list of Subnet IDs to allocate for the ASG |
| `security_group_ids` | list(String) | Yes | N/A | A list of Security Group IDs to attach to each EC2 Instance |
| `target_groups` | map(object) | No | `{}` | A map of Target Group objects to attach to the ASG. [See Below](#target-groups)
| `user_data` | String | No | `""` | Specify the path to a user_data script or embed one directly |

---

### Block Device Mappings

```hcl
[{
  delete_on_termination = true
  device_name           = "/dev/xvda"
  encrypted             = false
  iops                  = 0
  kms_key_id            = ""
  throughput            = 0
  volume_size           = 50
  volume_type           = "gp3"
}]

```

### Target Groups

```hcl
[{
      deregistration_delay  = 300
      enable_healthcheck    = true
      enable_stickiness     = false
      group_port            = 80
      group_protocol        = "HTTP" | "HTTPS" | "TCP" | "TLS"
      health_check_interval = 30
      health_check_matcher  = "200-299"
      health_check_path     = "/"
      health_check_port     = 80
      health_check_protocol = "HTTP" | "HTTPS" | "TCP"
      health_check_timeout  = 30
      healthy_threshold     = 3
      stickiness_type       = "lb_cookie" | "app_cookie" | "source_ip_dest_ip"
      target_type           = "instance" | "ip"
      unhealthy_threshold   = 3
      vpc_id                = vpc-1a2b3c4d5e6f7g8h9
}]
```

---

## Output Variables

| Name | Resource Type | Description |
| ---- | ------------- | ------------- |
| `asg_id` | [AutoScalingGroup ID](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#id) | The `ID` of the new AutoScalingGroup |
| `asg_arn` | [AutoScalingGroup ARN](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#arn) | The `ARN` of the new AutoScalingGroup |
| `asg_name` | [AutoScalingGroup Name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group#name) | The `Name` of the new AutoScalingGroup |
| `target_groups` | [Target Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/target_group) | A list of `Target Group` Objects |

---

## Usage

```hcl
module "asg" {
  source = "./modules/asg"

  block_device_mappings = [
    {
      device_name           = "/dev/xvda"
      delete_on_termination = true
      encrypted             = true
      iops                  = "3000"
      kms_key_id            = "arn:aws:kms:us-east-1:123456789012:key/1a2b3c4d-1a2b-3c4d-5e6f-1a2b3c4d5e6f"
      throughput            = "125"
      volume_size           = "50"
      volume_type           = "gp3"
    },
    {
      device_name = "xvdf"
      delete_on_termination = true
      encrypted             = true
      iops                  = "3000"
      kms_key_id            = "arn:aws:kms:us-east-1:123456789012:key/1a2b3c4d-1a2b-3c4d-5e6f-1a2b3c4d5e6f"
      throughput            = "500"
      volume_size           = "250"
      volume_type           = "gp3"
    }
  ]

  healthcheck_grace_period = 300
  healthcheck_type         = "ELB"
  iam_instance_profile     = "ec2_instance_profile"
  image_id                 = "ami-0a1b2c3d4e5f6g7h8i9"
  instance_type            = "c5.xlarge"
  max_size                 = 6
  min_size                 = 1
  server_name              = "app_server"
  subnets                  = ["subnet-1a2b3c4d5e", "subnet-6f7g8h9i0k"]
  security_group_ids       = ["sg-1a2b3c4d5e", "sg-6f7g8h9i0k"]

  target_groups = [
    {
      deregistration_delay  = 30
      enable_healthcheck    = true
      enable_stickiness     = true
      group_port            = 80
      group_protocol        = "HTTP"
      health_check_interval = 30
      health_check_matcher  = "200-299"
      health_check_path     = "/"
      health_check_port     = 80
      health_check_protocol = "HTTP"
      health_check_timeout  = 5 seconds
      healthy_threshold     = 3
      stickiness_type       = "lb_cookie"
      target_type           = "instance"
      unhealthy_threshold   = 3
      vpc_id                = "vpc-1a2b3c4d5e6f7g8h9"
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

## Authors

Mike Lynch ([mlynch1985@gmail.com](mailto:mlynch1985@gmail.com))
