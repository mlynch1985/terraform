resource "aws_lb" "this" {
  ## Required
  name               = "${var.namespace}-${var.component}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets

  ## ALB
  security_groups            = var.load_balancer_type == "application" ? var.security_groups : null
  drop_invalid_header_fields = var.load_balancer_type == "application" ? var.drop_invalid_header_fields : null
  idle_timeout               = var.load_balancer_type == "application" ? var.idle_timeout : null
  enable_http2               = var.load_balancer_type == "application" ? var.enable_http2 : null

  ## NLB
  enable_cross_zone_load_balancing = var.load_balancer_type == "network" ? var.enable_cross_zone_load_balancing : null

  ## Optional
  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/loadbal"
    )
  )
}

resource "aws_ssm_parameter" "this" {
  name      = "/${var.namespace}/${var.component}/loadbal_dns"
  type      = "String"
  overwrite = true
  value     = aws_lb.this.dns_name
}
