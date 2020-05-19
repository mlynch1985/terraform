## Define our target group
resource "aws_lb_target_group" "targetgroup-linuxjump" {
  name     = "${var.namespace}-targetgroup-linuxjump"
  port     = 22
  protocol = "TCP"
  vpc_id   = data.aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-targetgroup-linuxjump"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our Network Load Balancer
resource "aws_lb" "nlb-linuxjump" {
  name               = "${var.namespace}-nlb-linuxjump"
  internal           = false
  load_balancer_type = "network"
  subnets            = data.aws_subnet_ids.public-subnets.ids
  tags = {
    Name = "${var.namespace}-nlb-linuxjump"
    Environment = var.environment
    Namespace   = var.namespace
  }
}

## Define our NLB Listener
resource "aws_lb_listener" "listener-linuxjump" {
  load_balancer_arn = aws_lb.nlb-linuxjump.arn
  port              = "22"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.targetgroup-linuxjump.arn
  }
}
