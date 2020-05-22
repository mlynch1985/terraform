## Define our target group
resource "aws_lb_target_group" "linuxwordpress" {
  name     = "${var.namespace}-linuxwordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}_linuxwordpress_targetgroup"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Application Load Balancer
resource "aws_lb" "linuxwordpress" {
  name               = "${var.namespace}-linuxwordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_group.allow_vpc_http.id}", "${data.aws_security_group.allow_office_http.id}"]
  subnets            = data.aws_subnet_ids.subnets_public.ids
  tags = {
    Name        = "${var.namespace}_alb_linuxwordpress"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our ALB Listener
resource "aws_lb_listener" "linuxwordpress" {
  load_balancer_arn = aws_lb.linuxwordpress.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.linuxwordpress.arn
  }
}
