## Define our target group
resource "aws_lb_target_group" "elasticsearch" {
  name     = "${var.namespace}-elasticsearch"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc.id
  health_check {
    enabled = true
    interval = 15
    path = "/"
    port = 5601
    protocol = "HTTP"
    timeout = 5
    healthy_threshold = 2
    unhealthy_threshold = 3
    matcher = "200-302"
  }

  tags = {
    Name        = "${var.namespace}_elasticsearch_targetgroup"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Application Load Balancer
resource "aws_lb" "elasticsearch" {
  name               = "${var.namespace}-elasticsearch"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${data.aws_security_group.allow_vpc_http.id}", "${data.aws_security_group.allow_office_http.id}"]
  subnets            = data.aws_subnet_ids.subnets_public.ids
  tags = {
    Name        = "${var.namespace}_alb_elasticsearch"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our ALB Listener
resource "aws_lb_listener" "elasticsearch" {
  load_balancer_arn = aws_lb.elasticsearch.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elasticsearch.arn
  }
}
