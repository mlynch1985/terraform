## Define our target group
resource "aws_lb_target_group" "targetgroup-windowsjump" {
  name     = "${var.namespace}-targetgroup-windowsjump"
  port     = 3389
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-targetgroup-windowsjump"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Network Load Balancer
resource "aws_lb" "nlb-windows-jump" {
  name               = "${var.namespace}-nlb-windowsjump"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.public-subnets.ids
  tags = {
    Name = "${var.namespace}-nlb-windowsjump"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our NLB Listener
resource "aws_lb_listener" "listener-windowsjump" {
  load_balancer_arn = aws_lb.nlb-windows-jump.arn
  port              = "3389"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup-windowsjump.arn
  }
}
