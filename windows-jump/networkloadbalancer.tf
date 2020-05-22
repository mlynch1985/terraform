## Define our target group
resource "aws_lb_target_group" "windowsjump" {
  name     = "${var.namespace}-windowsjump"
  port     = 3389
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}_windowsjump_targetgroup"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Network Load Balancer
resource "aws_lb" "windowsjump" {
  name               = "${var.namespace}-windowsjump"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.subnets_public.ids
  tags = {
    Name        = "${var.namespace}_windowsjump_nlb"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our NLB Listener
resource "aws_lb_listener" "windowsjump" {
  load_balancer_arn = aws_lb.windowsjump.arn
  port              = "3389"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.windowsjump.arn
  }
}
