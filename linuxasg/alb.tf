resource "aws_lb" "elb" {
    name = "sample-linuxasg-elb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.elb.id]
    subnets = [for id in data.aws_subnet_ids.public.ids : id]
    tags = {
        Name = "sample-linuxasg-elb"
    }
}

resource "aws_lb_target_group" "group" {
    name = "sample-linuxasg-targetgroup"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.vpc.id
    target_type = "instance"
    health_check {
        enabled = true
        interval = 10
        path = "/"
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 3
        matcher = "200-403" # 403 because Apache throws by default
    }
    tags = {
        Name = "sample-linuxasg-targetgroup"
    }
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.group.arn
    }
}
