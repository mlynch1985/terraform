resource "aws_launch_template" "template" {
    name = "sample-linuxasg-template"
    iam_instance_profile {
        arn = aws_iam_instance_profile.profile.arn
    }
    instance_type = "t3a.micro"
    vpc_security_group_ids = [aws_security_group.asg.id]
    image_id = data.aws_ami.amazon-linux-2.image_id
    tag_specifications {
        resource_type = "instance"
        tags = {
            Name = "sample-linuxasg"
        }
    }
    user_data = filebase64("${path.module}/userdata.sh")
}

resource "aws_autoscaling_group" "asg" {
    name = "sample-linuxasg-asg"
    max_size = 6
    min_size = 3
    desired_capacity = 3
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    launch_template {
        version = "$Latest"
        id = aws_launch_template.template.id
    }
    vpc_zone_identifier = [for id in data.aws_subnet_ids.private.ids : id]
    target_group_arns = [aws_lb_target_group.group.arn]
}
