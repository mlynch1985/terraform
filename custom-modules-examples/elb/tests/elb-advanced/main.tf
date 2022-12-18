resource "aws_security_group" "tester" {
  #checkov:skip=CKV2_AWS_5:Ensure that Security Groups are attached to another resource
  name_prefix = "elb_tester_"
  description = "SG Used to test the ELB Terraform Module"
  vpc_id      = var.vpc_id

  egress {
    description      = "Allow all outbound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "elb_tester"
  }
}

module "elb" {
  source = "../../../../custom-modules-examples/elb"

  bucket_name                      = "mltest-access-logs"
  drop_invalid_header_fields       = true
  enable_cross_zone_load_balancing = false
  idle_timeout                     = 30
  is_internal                      = false
  lb_type                          = "application"
  name_tag                         = "elb-tester"
  security_groups                  = [aws_security_group.tester.id]
  subnets                          = data.aws_subnets.tester.ids

  listeners = {
    "http_redirect" = {
      alpn_policy       = null
      certificate_arn   = null
      listener_port     = 80
      listener_protocol = "HTTP"
      ssl_policy        = null

      default_action = {
        action_type    = "redirect"
        fixed_response = null
        forward        = null

        redirect = [{
          redirect_status_code = "HTTP_302"
          redirect_host        = "#{host}"
          redirect_path        = "/#{path}"
          redirect_port        = 443
          redirect_protocol    = "HTTPS"
        }]
      }
    },
    "https_fixed" = {
      alpn_policy       = null
      certificate_arn   = var.certificate_arn
      listener_port     = 443
      listener_protocol = "HTTPS"
      ssl_policy        = "ELBSecurityPolicy-2016-08"

      default_action = {
        action_type = "fixed-response"
        forward     = null
        redirect    = null

        fixed_response = [{
          content_type      = "text/plain"
          message_body      = "Hello World!"
          fixed_status_code = 200
        }]
      }
    }
  }
}
