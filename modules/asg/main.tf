resource "aws_launch_template" "root_drive_only" {
  count = var.enable_second_drive ? 0 : 1

  name_prefix            = "${var.namespace}/${var.component}/"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  user_data              = var.user_data

  block_device_mappings {
    device_name = var.root_block_device.device_name

    ebs {
      volume_type           = var.root_block_device.volume_type
      volume_size           = var.root_block_device.volume_size
      delete_on_termination = var.root_block_device.delete_on_termination
      encrypted             = var.root_block_device.encrypted
      kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.this.key_id : ""
    }
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.default_tags,
      map(
        "Name", "${var.namespace}_${var.component}"
      )
    )
  }
}

resource "aws_launch_template" "with_ebs_drive" {
  count = var.enable_second_drive ? 1 : 0

  name_prefix            = "${var.namespace}/${var.component}/"
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  user_data              = var.user_data

  block_device_mappings {
    device_name = var.root_block_device.device_name

    ebs {
      volume_type           = var.root_block_device.volume_type
      volume_size           = var.root_block_device.volume_size
      delete_on_termination = var.root_block_device.delete_on_termination
      encrypted             = var.root_block_device.encrypted
      kms_key_id            = var.root_block_device.encrypted ? aws_kms_key.this.key_id : ""
    }
  }

  block_device_mappings {
    device_name = var.ebs_block_device.device_name

    ebs {
      volume_type           = var.ebs_block_device.volume_type
      volume_size           = var.ebs_block_device.volume_size
      delete_on_termination = var.ebs_block_device.delete_on_termination
      encrypted             = var.ebs_block_device.encrypted
      kms_key_id            = var.ebs_block_device.encrypted ? aws_kms_key.this.key_id : ""
    }
  }

  monitoring {
    enabled = var.enable_detailed_monitoring
  }

  iam_instance_profile {
    arn = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      var.default_tags,
      map(
        "Name", "${var.namespace}_${var.component}"
      )
    )
  }
}

resource "aws_autoscaling_group" "this" {
  name_prefix         = "${var.namespace}/${var.component}/"
  min_size            = var.asg_min
  max_size            = var.asg_max
  desired_capacity    = var.asg_desired
  health_check_type   = var.asg_healthcheck_type
  vpc_zone_identifier = var.asg_subnets
  target_group_arns   = var.target_group_arns

  launch_template {
    version = "$Latest"
    id      = var.enable_second_drive ? aws_launch_template.with_ebs_drive.id : aws_launch_template.root_drive_only.id
  }
}
