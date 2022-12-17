resource "aws_lb" "this" {
  #checkov:skip=CKV_AWS_91:Access Logging is parameterized
  #checkov:skip=CKV_AWS_131:Drop invalid headers is parameterized
  #checkov:skip=CKV_AWS_150:Disabling terminatio protection for demo purposes only
  #checkov:skip=CKV_AWS_152:Cross-Zone load balancing is parameterized
  #checkov:skip=CKV2_AWS_28:Not using a WAF for demo purposes only
  drop_invalid_header_fields       = var.lb_type == "application" ? var.drop_invalid_header_fields : null
  enable_cross_zone_load_balancing = var.lb_type == "network" ? var.enable_cross_zone_load_balancing : null
  idle_timeout                     = var.lb_type == "application" ? var.idle_timeout : null
  internal                         = var.is_internal #tfsec:ignore:aws-elb-alb-not-public
  load_balancer_type               = var.lb_type
  security_groups                  = var.lb_type == "application" ? var.security_groups : null
  subnets                          = var.subnets

  access_logs {
    bucket  = var.bucket_name
    enabled = var.bucket_name != null ? true : false
  }

  tags = {
    "Name" = var.name_tag
  }
}

resource "aws_lb_listener" "this" {
  #checkov:skip=CKV_AWS_2:Protocol is parameterized
  #checkov:skip=CKV_AWS_103:TLS is parameterized
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  alpn_policy       = each.value.alpn_policy
  certificate_arn   = each.value.certificate_arn
  port              = each.value.listener_port
  protocol          = each.value.listener_protocol
  ssl_policy        = each.value.ssl_policy

  default_action {
    type = each.value.default_action.action_type

    dynamic "fixed_response" {
      for_each = each.value.default_action.action_type == "fixed-response" ? each.value.default_action.fixed_response : []

      content {
        content_type = fixed_response.value.content_type
        message_body = fixed_response.value.message_body
        status_code  = fixed_response.value.fixed_status_code
      }
    }

    dynamic "forward" {
      for_each = each.value.default_action.action_type == "forward" ? each.value.default_action.forward : []

      content {
        dynamic "target_group" {
          for_each = forward.value.target_group_arns

          content {
            arn = target_group.value != "" ? target_group.value : null
          }
        }

        stickiness {
          duration = forward.value.stickiness_duration != 0 ? forward.value.stickiness_duration : 3600
          enabled  = forward.value.enable_stickiness
        }
      }
    }

    dynamic "redirect" {
      for_each = each.value.default_action.action_type == "redirect" ? each.value.default_action.redirect : []

      content {
        status_code = redirect.value.redirect_status_code
        host        = redirect.value.redirect_host
        path        = redirect.value.redirect_path
        port        = redirect.value.redirect_port
        protocol    = redirect.value.redirect_protocol
      }
    }
  }
}
