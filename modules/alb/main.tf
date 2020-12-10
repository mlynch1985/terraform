resource "aws_lb" "this" {
  name            = "${var.namespace}-${var.component}"
  internal        = var.is_internal
  security_groups = var.security_groups
  subnets         = var.subnets

  tags = merge(
    var.default_tags,
    map(
      "Name", "${var.namespace}/${var.component}/alb"
    )
  )
}

resource "aws_ssm_parameter" "this" {
  name      = "/${var.namespace}/${var.component}/alb_dns"
  type      = "String"
  overwrite = true
  value     = aws_lb.this.dns_name
}
