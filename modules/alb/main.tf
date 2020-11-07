resource "aws_lb" "this" {
  internal        = var.is_internal
  security_groups = var.security_groups
  subnets         = var.subnets

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.name}_alb"
    )
  )
}

resource "aws_lb_target_group" "this" {
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  stickiness {
    type    = "lb_cookie"
    enabled = var.enable_stickiness
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = "/"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.name}_target_group"
    )
  )
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  ssl_policy        = var.alb_listener_protocol == "HTTPS" ? "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : ""
  certificate_arn   = var.alb_listener_protocol == "HTTPS" && var.alb_listener_cert != "" ? var.alb_listener_cert : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
