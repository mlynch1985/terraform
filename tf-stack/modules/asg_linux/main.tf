resource "aws_security_group" "ec2" {
    vpc_id = var.vpc_id.id

    ingress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        security_groups = [var.common_security_group.id]
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_"
        )
    )
}

resource "aws_launch_template" "template" {
    name_prefix = "${var.default_tags.namespace}_"
    image_id = data.aws_ami.amazon_linux_2.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [var.common_security_group.id, aws_security_group.ec2.id]
    user_data = var.user_data

    iam_instance_profile {
        arn = var.ec2_role.profile.arn
    }

    tag_specifications {
        resource_type = "instance"
        tags = var.default_tags
    }
}

resource "aws_autoscaling_group" "asg" {
    name_prefix = "${var.default_tags.namespace}_"
    min_size = var.asg_min
    max_size = var.asg_max
    desired_capacity = var.asg_desired
    health_check_type = var.health_check_type
    vpc_zone_identifier = var.subnets.*.id
    target_group_arns = [var.target_group.arn]

    launch_template {
        version = "$Latest"
        id = aws_launch_template.template.id
    }
}
