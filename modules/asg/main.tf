resource "aws_launch_template" "this" {
  ebs_optimized          = true
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  user_data              = var.user_data

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  iam_instance_profile {
    arn = length(var.iam_instance_profile) > 0 ? var.iam_instance_profile : ""
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.default_tags,
      map(
        "Name", "${var.namespace}_${var.name}"
      )
    )
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.namespace}_${var.name}_asg"
  min_size            = var.asg_min
  max_size            = var.asg_max
  desired_capacity    = var.asg_desired
  health_check_type   = var.asg_healthcheck_type
  vpc_zone_identifier = var.asg_subnets
  target_group_arns   = var.target_group_arns

  launch_template {
    version = "$Latest"
    id      = aws_launch_template.this.id
  }
}
