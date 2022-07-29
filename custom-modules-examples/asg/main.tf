resource "aws_launch_template" "launch_template" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  name_prefix            = var.server_name
  vpc_security_group_ids = var.vpc_security_group_ids
  user_data              = var.user_data

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = lookup(block_device_mappings.value, "device_name", null)

      ebs {
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = true
        kms_key_id            = var.kms_key_arn
      }
    }
  }

  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = var.server_name
    }
  }
}

resource "aws_autoscaling_group" "asg" {
  #checkov:skip=CKV_AWS_153:We are leveraging Terraform Default Tags
  name_prefix               = var.server_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.healthcheck_grace_period
  health_check_type         = var.healthcheck_type
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnets
  target_group_arns         = var.target_group_arns

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }
}
