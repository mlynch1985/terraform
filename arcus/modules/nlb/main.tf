resource "aws_lb" "this" {
  #checkov:skip=CKV_AWS_91:Access Logging is parameterized
  #checkov:skip=CKV_AWS_131:Drop invalid headers is parameterized
  #checkov:skip=CKV_AWS_150:Disabling terminatio protection for demo purposes only
  #checkov:skip=CKV_AWS_152:Cross-Zone load balancing is parameterized
  #checkov:skip=CKV2_AWS_28:Not using a WAF for demo purposes only
  enable_cross_zone_load_balancing = true
  internal                         = true #tfsec:ignore:aws-elb-alb-not-public
  load_balancer_type               = "network"
  subnets                          = var.subnets
}

resource "aws_lb_listener" "ssh" {
  #checkov:skip=CKV_AWS_2:Protocol is parameterized
  #checkov:skip=CKV_AWS_103:TLS is parameterized

  load_balancer_arn = aws_lb.this.arn
  alpn_policy       = "HTTP2Preferred"
  certificate_arn   = var.certificate_arn
  port              = 22
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssh.arn
  }
}

resource "aws_lb_listener" "http" {
  #checkov:skip=CKV_AWS_2:Protocol is parameterized
  #checkov:skip=CKV_AWS_103:TLS is parameterized

  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_target_group" "ssh" {
  name     = "bastion1-ssh"
  port     = 22
  protocol = "TLS"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "http" {
  name     = "bastion1-http"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "ssh" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.ssh.arn
  target_id        = var.instance_ids[count.index]
  port             = 22
}

resource "aws_lb_target_group_attachment" "http" {
  count = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.http.arn
  target_id        = var.instance_ids[count.index]
  port             = 80
}
