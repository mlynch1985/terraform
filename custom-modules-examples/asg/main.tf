resource "aws_launch_template" "this" {
  image_id               = var.image_id
  instance_type          = var.instance_type
  name_prefix            = var.server_name
  user_data              = var.user_data
  vpc_security_group_ids = var.security_group_ids

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings

    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
        iops                  = block_device_mappings.value.iops >= 3000 ? block_device_mappings.value.iops : null
        kms_key_id            = block_device_mappings.value.kms_key_id != "" ? block_device_mappings.value.kms_key_id : null
        throughput            = block_device_mappings.value.throughput >= 125 ? block_device_mappings.value.throughput : null
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
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
    ignore_changes = [load_balancers, target_group_arns]
  }

  name_prefix               = var.server_name
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.healthcheck_grace_period
  health_check_type         = var.healthcheck_type
  target_group_arns         = [for group in aws_lb_target_group.this : group.arn]
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

resource "aws_autoscaling_policy" "this" {
  name                   = "${var.server_name}-cpu-based-scaling"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = 80

    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}

resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  deregistration_delay = each.value.deregistration_delay != 0 ? each.value.deregistration_delay : null
  port                 = each.value.group_port
  protocol             = each.value.group_protocol
  target_type          = each.value.target_type != "" ? each.value.target_type : "instance"
  vpc_id               = each.value.vpc_id

  health_check {
    enabled             = each.value.enable_healthcheck
    healthy_threshold   = each.value.healthy_threshold != 0 ? each.value.healthy_threshold : null
    interval            = each.value.health_check_interval != 0 ? each.value.health_check_interval : null
    matcher             = each.value.health_check_matcher != "" ? each.value.health_check_matcher : null
    path                = each.value.health_check_path != "" ? each.value.health_check_path : null
    port                = each.value.health_check_port != 0 ? each.value.health_check_port : null
    protocol            = each.value.health_check_protocol != "" ? each.value.health_check_protocol : null
    timeout             = each.value.health_check_timeout != 0 ? each.value.health_check_timeout : null
    unhealthy_threshold = each.value.unhealthy_threshold != 0 ? each.value.unhealthy_threshold : null
  }

  stickiness {
    enabled = each.value.enable_stickiness
    type    = each.value.stickiness_type != "" ? each.value.stickiness_type : "lb_cookie"
  }
}
