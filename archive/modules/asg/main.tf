resource "aws_launch_template" "this" {
  ## Required
  name_prefix            = "${var.namespace}/${var.component}/"
  image_id               = var.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.vpc_security_group_ids

  ## Optional
  update_default_version  = var.update_default_version
  disable_api_termination = var.disable_api_termination
  key_name                = var.key_name
  user_data               = var.user_data

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = lookup(block_device_mappings.value, "device_name", null)

      ebs {
        volume_type           = lookup(block_device_mappings.value, "volume_type", null)
        volume_size           = lookup(block_device_mappings.value, "volume_size", null)
        iops                  = lookup(block_device_mappings.value, "iops", null)
        delete_on_termination = lookup(block_device_mappings.value, "delete_on_termination", null)
        encrypted             = lookup(block_device_mappings.value, "encrypted", null)
        kms_key_id            = lookup(block_device_mappings.value, "encrypted", false) ? aws_kms_key.this.arn : ""
      }
    }
  }

  monitoring {
    enabled = var.monitoring
  }

  iam_instance_profile {
    arn = var.iam_instance_profile.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.default_tags,
      map(
        "Name", "${var.namespace}/${var.component}"
      )
    )
  }
}

resource "aws_autoscaling_group" "this" {
  ## Required
  name_prefix         = "${var.namespace}/${var.component}/"
  vpc_zone_identifier = var.subnets

  ## Optional
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  default_cooldown          = var.default_cooldown
  capacity_rebalance        = var.capacity_rebalance
  health_check_grace_period = var.healthcheck_grace_period
  health_check_type         = var.healthcheck_type
  force_delete              = var.force_delete
  target_group_arns         = var.target_group_arns
  termination_policies      = var.termination_policies
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  # service_linked_role_arn   = var.service_linked_role_arn  // Requires updates to kms.tf policies to use custom roles

  launch_template {
    version = "$Latest"
    id      = aws_launch_template.this.id
  }
}
