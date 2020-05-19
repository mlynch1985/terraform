## Define our target group
resource "aws_lb_target_group" "targetgroup-linuxwordpress" {
  name     = "${var.namespace}-targetgroup-wordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}-targetgroup-linuxwordpress"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Application Load Balancer
resource "aws_lb" "alb-linuxwordpress" {
  name               = "${var.namespace}-alb-linuxwordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_group.sg-allow-http.id}", "${aws_security_group.allow-remote-http.id}"]
  subnets            = data.aws_subnet_ids.public-subnets.ids
  tags = {
    Name        = "${var.namespace}-alb-linuxwordpress"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our ALB Listener
resource "aws_lb_listener" "listener-linuxwordpress" {
  load_balancer_arn = aws_lb.alb-linuxwordpress.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup-linuxwordpress.arn
  }
}
