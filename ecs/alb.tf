resource "aws_lb" "elb" {
    name = "sample-ecs-elb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.elb.id]
    subnets = [for id in data.aws_subnet_ids.public.ids : id]
    tags = {
        Name = "sample-ecs-elb"
    }
}

resource "aws_lb_target_group" "group" {
    name = "sample-ecs-targetgroup"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.vpc.id
    target_type = "ip"
    tags = {
        Name = "sample-ecs-targetgroup"
    }
}

resource "aws_lb_listener" "listener" {
    depends_on = [aws_lb_target_group.group]
    load_balancer_arn = aws_lb.elb.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.group.arn
    }
}
