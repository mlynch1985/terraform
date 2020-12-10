resource "aws_lb" "this" {
  name                             = "${var.namespace}-${var.component}"
  internal                         = var.is_internal
  load_balancer_type               = "network"
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/nlb"
    )
  )
}

resource "aws_ssm_parameter" "this" {
  name      = "/${var.namespace}/${var.component}/nlb_dns"
  type      = "String"
  overwrite = true
  value     = aws_lb.this.dns_name
}
