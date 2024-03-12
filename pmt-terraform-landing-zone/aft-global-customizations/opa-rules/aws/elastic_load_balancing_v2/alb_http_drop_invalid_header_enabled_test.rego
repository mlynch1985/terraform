package aws.elastic_load_balancing_v2.alb_http_drop_invalid_header_enabled

test_alb_http_drop_invalid_header_enabled_valid {
	count(violations) == 0 with input as data.alb_http_drop_invalid_header_enabled.valid
}

test_alb_http_drop_invalid_header_enabled_ignore {
	count(violations) == 0 with input as data.alb_http_drop_invalid_header_enabled.ignore
}

test_alb_http_drop_invalid_header_enabled_invalid {
	r := violations with input as data.alb_http_drop_invalid_header_enabled.invalid
	count(r) == 1
	r[_].finding.title = "ALB_HTTP_DROP_INVALID_HEADER_ENABLED"
	r[_].finding.uid = "ALB-2"
}

test_alb_http_drop_invalid_header_enabled_no_drop {
	r := violations with input as data.alb_http_drop_invalid_header_enabled.no_drop
	count(r) == 1
	r[_].finding.title = "ALB_HTTP_DROP_INVALID_HEADER_ENABLED"
	r[_].finding.uid = "ALB-2"
}
