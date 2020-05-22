## Define our target group
resource "aws_lb_target_group" "linuxjump" {
  name     = "${var.namespace}-linuxjump"
  port     = 22
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name        = "${var.namespace}_linuxjump_targetgroup"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Network Load Balancer
resource "aws_lb" "linuxjump" {
  name               = "${var.namespace}-linuxjump"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.subnets_public.ids
  tags = {
    Name        = "${var.namespace}_linuxjump_nlb"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our NLB Listener
resource "aws_lb_listener" "linuxjump" {
  load_balancer_arn = aws_lb.linuxjump.arn
  port              = "22"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.linuxjump.arn
  }
}
