resource "aws_lb" "this" {
  drop_invalid_header_fields       = var.lb_type == "application" ? var.drop_invalid_header_fields : null
  enable_cross_zone_load_balancing = var.lb_type == "network" ? var.enable_cross_zone_load_balancing : null
  idle_timeout                     = var.lb_type == "application" ? var.idle_timeout : null
  internal                         = var.is_internal
  load_balancer_type               = var.lb_type
  security_groups                  = var.lb_type == "application" ? var.security_groups : null
  subnets                          = var.subnets

  access_logs {
    bucket  = var.bucket_name
    enabled = var.enable_access_logs
  }

  tags = {
    "Name" = var.name
  }
}

resource "aws_lb_listener" "this" {
  for_each = { for listener in var.listeners : listener.listener_protocol => listener }

  certificate_arn   = each.value.certificate_arn != "" ? each.value.certificate_arn : null
  load_balancer_arn = aws_lb.this.arn
  port              = each.value.listener_port != 0 ? each.value.listener_port : null
  protocol          = each.value.listener_protocol != "" ? each.value.listener_protocol : null
  ssl_policy        = each.value.ssl_policy != "" ? each.value.ssl_policy : null

  default_action {
    type = each.value.default_action.action_type

    dynamic "fixed_response" {
      for_each = each.value.default_action.action_type == "fixed-response" ? each.value.default_action.fixed_response : []

      content {
        content_type = fixed_response.value.content_type != "" ? fixed_response.value.content_type : null
        message_body = fixed_response.value.message_body != "" ? fixed_response.value.message_body : null
        status_code  = fixed_response.value.fixed_status_code != 0 ? fixed_response.value.fixed_status_code : null
      }
    }

    dynamic "forward" {
      for_each = each.value.default_action.action_type == "forward" ? each.value.default_action.forward : []

      content {
        target_group {
          arn    = forward.value.target_group_arn != "" ? forward.value.target_group_arn : null
          weight = forward.value.target_group_weight != 0 ? forward.value.target_group_weight : null
        }

        stickiness {
          duration = forward.value.stickiness_duration != 0 ? forward.value.stickiness_duration : null
          enabled  = forward.value.enable_stickiness != "" ? forward.value.enable_stickiness : null
        }
      }
    }

    dynamic "redirect" {
      for_each = each.value.default_action.action_type == "redirect" ? each.value.default_action.redirect : []

      content {
        host        = redirect.value.redirect_host != "" ? redirect.value.redirect_host : null
        path        = redirect.value.redirect_path != "" ? redirect.value.redirect_path : null
        port        = redirect.value.redirect_port != 0 ? redirect.value.redirect_port : null
        protocol    = redirect.value.redirect_protocol != "" ? redirect.value.redirect_protocol : null
        status_code = redirect.value.redirect_status_code != 0 ? redirect.value.redirect_status_code : null
      }
    }
  }
}
