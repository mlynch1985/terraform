package aws.elastic_load_balancing_v2.alb_http_to_https_redirection_check

test_alb_http_to_https_redirection_check_valid {
	count(violations) == 0 with input as data.alb_http_to_https_redirection_check.valid
}

test_alb_http_to_https_redirection_check_ignore {
	count(violations) == 0 with input as data.alb_http_to_https_redirection_check.ignore
}

test_alb_http_to_https_redirection_check_invalid {
	r := violations with input as data.alb_http_to_https_redirection_check.invalid
	count(r) == 1
	r[_].finding.title = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
	r[_].finding.uid = "ALB-3"
}

test_alb_http_to_https_redirection_check_default_forward {
	r := violations with input as data.alb_http_to_https_redirection_check.default_forward
	count(r) == 1
	r[_].finding.title = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
	r[_].finding.uid = "ALB-3"
}

test_alb_http_to_https_redirection_redirect_http {
	r := violations with input as data.alb_http_to_https_redirection_check.redirect_http
	count(r) == 1
	r[_].finding.title = "ALB_HTTP_TO_HTTPS_REDIRECTION_CHECK"
	r[_].finding.uid = "ALB-3"
}

test_alb_http_to_https_redirection_check_no_HTTP {
	count(violations) == 0 with input as data.alb_http_to_https_redirection_check.no_HTTP
}
