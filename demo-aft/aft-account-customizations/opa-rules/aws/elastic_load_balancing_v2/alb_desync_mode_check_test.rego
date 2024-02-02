package aws.elastic_load_balancing_v2.alb_desync_mode_check

test_alb_desync_mode_check_valid {
	count(violations) == 0 with input as data.alb_desync_mode_check.valid
}

test_alb_desync_mode_check_ignore {
	count(violations) == 0 with input as data.alb_desync_mode_check.ignore
}

test_alb_desync_mode_check_invalid {
	r := violations with input as data.alb_desync_mode_check.invalid
	count(r) == 1
	r[_].finding.title = "ALB_DESYNC_MODE_CHECK"
	r[_].finding.uid = "ALB-1"
}

test_alb_desync_mode_check_no_desync {
	count(violations) == 1 with input as data.alb_desync_mode_check.no_desync
}
