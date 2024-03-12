package aws.elastic_load_balancing.elb_logging_enabled

test_elb_logging_enabled_valid {
	count(violations) == 0 with input as data.elb_logging_enabled.valid
}

test_elb_logging_enabled_ignore {
	count(violations) == 0 with input as data.elb_logging_enabled.ignore
}

test_elb_logging_enabled_invalid {
	r := violations with input as data.elb_logging_enabled.invalid
	count(r) == 1
	r[_].finding.title = "ELB_LOGGING_ENABLED"
	r[_].finding.uid = "ELB-1"
}
