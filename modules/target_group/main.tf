resource "aws_lb_target_group" "this" {
  name                 = "${var.namespace}-${var.component}-${var.elb_listener_port}"
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  stickiness {
    type    = var.elb_type == "ALB" ? "lb_cookie" : "source_ip"
    enabled = var.enable_stickiness
  }

  health_check {
    enabled             = true
    path                = var.elb_type == "ALB" ? var.healthcheck_path : ""
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = var.elb_type == "ALB" ? "200-399" : ""
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/target_group"
    )
  )
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = var.elb_arn
  port              = var.elb_listener_port
  protocol          = var.elb_listener_protocol
  ssl_policy        = var.elb_listener_protocol == "HTTPS" ? "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : ""
  certificate_arn   = var.elb_listener_protocol == "HTTPS" && var.elb_listener_cert != "" ? var.elb_listener_cert : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count = length(var.target_ids) > 0 ? length(var.target_ids) : 0

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_ids[count.index]
}
