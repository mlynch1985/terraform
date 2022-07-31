resource "aws_launch_template" "this" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  name_prefix            = var.server_name
  user_data              = var.user_data
  vpc_security_group_ids = var.vpc_security_group_ids

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = lookup(block_device_mappings.value, "device_name", null)

      ebs {
        volume_type           = lookup(block_device_mappings.value, "volume_type", null) # Convert to simpler syntax
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = true            # ToDo: make optional parameter
        kms_key_id            = var.kms_key_arn # ToDo: make optional parameter
      }
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
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

resource "aws_autoscaling_group" "this" {
  // Use the "autoscaling_attachment" resource to manage ELB/TargetGroup attachments
  // Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
  lifecycle {
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }

  name_prefix               = var.server_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.healthcheck_grace_period
  health_check_type         = var.healthcheck_type
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.subnets

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.server_name
    propagate_at_launch = true
  }
}
