resource "aws_lb" "alb" {
    internal = var.internal
    load_balancer_type = "application"
    security_groups = [ var.common_security_group.id, aws_security_group.alb.id]
    subnets = var.subnets.*.id

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_alb"
        )
    )
}

resource "aws_lb_target_group" "group" {
    port = var.port
    protocol = var.protocol
    vpc_id = var.vpc_id.id
    target_type = "instance"

    stickiness {
        type = "lb_cookie"
        enabled = var.enable_stickiness
    }

    health_check {
        enabled = true
        interval = 15
        path = "/"
        protocol = var.protocol
        timeout = 5
        healthy_threshold = 2
        unhealthy_threshold = 3
        matcher = "200-403"
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_target_group"
        )
    )
}

resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn
    port = var.port
    protocol = var.protocol
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.group.arn
    }
}

resource "aws_security_group" "alb" {
    vpc_id = var.vpc_id.id

    ingress {
        protocol = "TCP"
        from_port = var.port
        to_port = var.port
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(
        var.default_tags,
        map(
            "Name", "${var.default_tags.namespace}_alb"
        )
    )
}
