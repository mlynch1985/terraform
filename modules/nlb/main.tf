resource "aws_lb" "this" {
  name                             = "${var.namespace}-${var.app_role}"
  internal                         = var.is_internal
  load_balancer_type               = "network"
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_nlb"
    )
  )
}

resource "aws_lb_target_group" "this" {
  name                 = "${var.namespace}-${var.app_role}"
  port                 = var.target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  stickiness {
    type    = "lb_cookie"
    enabled = var.enable_stickiness
  }

  health_check {
    enabled             = true
    interval            = 15
    path                = var.healthcheck_path
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}_${var.app_role}_target_group"
    )
  )
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.nlb_listener_port
  protocol          = var.nlb_listener_protocol
  ssl_policy        = var.nlb_listener_protocol == "HTTPS" ? "ELBSecurityPolicy-TLS-1-2-Ext-2018-06" : ""
  certificate_arn   = var.nlb_listener_protocol == "HTTPS" && var.nlb_listener_cert != "" ? var.nlb_listener_cert : ""

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_ssm_parameter" "this" {
  name  = "/${var.namespace}/${var.app_role}/nlb_dns"
  type  = "String"
  value = aws_lb.this.dns_name
}
